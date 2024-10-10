{
  stdenv,
  lib,
  testers,
  fetchurl,
  pkg-config,
  makeWrapper,
  autoreconfHook,
  bash-completion,
  OVMF,
  qemu,
  ocamlPackages,
  perl,
  cpio,
  getopt,
  libosinfo,
  pcre2,
  libxml2,
  jansson,
  glib,
  libguestfs-with-appliance,
  cdrkit,
  nbdkit ? null,
  ocaml_libnbd ? null,
  withWindowsGuestSupport ? true,
  mingw-srvany ? null,
  virtio-win,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virt-v2v";
  version = "2.4.0";

  src = fetchurl {
    url = "https://download.libguestfs.org/virt-v2v/${lib.versions.majorMinor finalAttrs.version}-stable/virt-v2v-${finalAttrs.version}.tar.gz";
    sha256 = "0iygrqykdq9jsjlshlz68qbyyc2r4vlwhqwx9nld7kn8fk4cy4y4";
  };

  prePatch = ''
    patchShebangs .
  '';

  postPatch = ''
    substituteInPlace common/mlv2v/uefi.ml \
        --replace-fail '/usr/share/OVMF/OVMF_CODE.fd' "${OVMF.firmware}" \
        --replace-fail '/usr/share/OVMF/OVMF_VARS.fd' "${OVMF.variables}"
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    makeWrapper
    bash-completion
    perl
    libguestfs-with-appliance
    qemu
    cpio
    cdrkit
    getopt
    ocamlPackages.findlib
    ocamlPackages.ocaml
    ocamlPackages.ocaml_libvirt
    ocaml_libnbd
    #ocamlPackages.nbd
  ];

  buildInputs = [
    libosinfo
    pcre2
    libxml2
    jansson
    glib
  ];

  postInstall =
    ''
      for bin in $out/bin/*; do
        wrapProgram "$bin" \
          --prefix PATH : "$out/bin:${nbdkit}/bin:${qemu}/bin"
      done
    ''
    + lib.optionalString withWindowsGuestSupport ''
      ln -s "${virtio-win}" $out/share/virtio-win
      ln -s "${mingw-srvany}" $out/share/virt-tools
    '';

  PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR = "${placeholder "out"}/share/bash-completion/completions";

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = with lib; {
    homepage = "https://github.com/libguestfs/virt-v2v";
    description = "Virt-v2v converts guests from foreign hypervisors to run on KVM";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lukts30 ];
    platforms = with platforms; unix;
    mainProgram = "virt-v2v";
  };
})
