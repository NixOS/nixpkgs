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
  nbdkit,
  withWindowsGuestSupport ? true,
  pkgsCross, # for rsrvany
  virtio-win,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virt-v2v";
  version = "2.6.0";

  src = fetchurl {
    url = "https://download.libguestfs.org/virt-v2v/${lib.versions.majorMinor finalAttrs.version}-stable/virt-v2v-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-W7t/n1QO9UebyH85abtnSY5i7kH/6h8JIAlFQoD1vkU=";
  };

  postPatch = ''
    substituteInPlace common/mlv2v/uefi.ml \
        --replace-fail '/usr/share/OVMF/OVMF_CODE.fd' "${OVMF.firmware}" \
        --replace-fail '/usr/share/OVMF/OVMF_VARS.fd' "${OVMF.variables}"

    patchShebangs .
  '';

  nativeBuildInputs =
    [
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
    ]
    ++ (with ocamlPackages; [
      ocaml
      findlib
    ]);

  buildInputs =
    [
      libosinfo
      pcre2
      libxml2
      jansson
      glib
    ]
    ++ (with ocamlPackages; [
      ocaml_libvirt
      nbd
    ]);

  postInstall =
    ''
      for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH : "$out/bin:${
          lib.makeBinPath [
            nbdkit
            qemu
          ]
        }"
      done
    ''
    + lib.optionalString withWindowsGuestSupport ''
      ln -s "${virtio-win}" $out/share/virtio-win
      ln -s "${pkgsCross.mingwW64.rhsrvany}/bin/" $out/share/virt-tools
    '';

  PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR = "${placeholder "out"}/share/bash-completion/completions";

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/libguestfs/virt-v2v";
    description = "Convert guests from foreign hypervisors to run on KVM";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lukts30 ];
    platforms = lib.platforms.linux;
    mainProgram = "virt-v2v";
  };
})
