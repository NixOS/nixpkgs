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
  json_c,
  glib,
  libguestfs-with-appliance,
  cdrkit,
  nbdkit,
  withWindowsGuestSupport ? true,
  pkgsCross, # for rsrvany
  virtio-win,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virt-v2v";
  version = "2.8.1";

  src = fetchurl {
    url = "https://download.libguestfs.org/virt-v2v/${lib.versions.majorMinor finalAttrs.version}-stable/virt-v2v-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-RJPwtI6GHN+W+Pw8jdEAgQMbR42aGqTYW2rPtAYBPYM=";
  };

  postPatch = ''
    # TODO: allow guest != host CPU ISA
    substituteInPlace output/output_qemu.ml \
        --replace-fail '/usr/share/OVMF' ""${OVMF.fd}/FV/" \
        --replace-fail '/usr/share/AAVMF' ""${OVMF.fd}/FV/"

    patchShebangs .
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
  ]
  ++ (with ocamlPackages; [
    ocaml
    findlib
  ]);

  buildInputs = [
    json_c
    libosinfo
    pcre2
    libxml2
    glib
  ]
  ++ (with ocamlPackages; [
    ocaml_libvirt
    nbd
  ]);

  postInstall = ''
    for bin in $out/bin/*; do
    wrapProgram "$bin" \
      --prefix PATH : "$out/bin:${
        lib.makeBinPath [
          nbdkit
          ocamlPackages.nbd
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

  passthru.updateScript = gitUpdater {
    url = "https://github.com/libguestfs/guestfs-tools";
    rev-prefix = "v";
    odd-unstable = true;
  };

  meta = {
    homepage = "https://github.com/libguestfs/virt-v2v";
    description = "Convert guests from foreign hypervisors to run on KVM";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lukts30 ];
    platforms = lib.platforms.linux;
    mainProgram = "virt-v2v";
  };
})
