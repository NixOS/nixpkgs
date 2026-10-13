{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  libuuid,
  lvm2_dmeventd, # <libdevmapper-event.h>
  zlib,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vdo";
  version = "8.3.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dm-vdo";
    repo = "vdo";
    tag = finalAttrs.version;
    hash = "sha256-y3u9f17jMV9dwhfJrsW/GOqszVNvPLDyETfku1t3Djo=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    libuuid
    lvm2_dmeventd
    zlib
    python3.pkgs.wrapPython
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
  ];

  pythonPath = finalAttrs.propagatedBuildInputs;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "INSTALLOWNER="
    # all of these paths are relative to DESTDIR and have defaults that don't work for us
    "bindir=/bin"
    "defaultdocdir=/share/doc"
    "mandir=/share/man"
    "python3_sitelib=${python3.sitePackages}"
  ];

  # riscv64 GCC reports -Wcast-align, which the Makefiles turn into errors with -Werror
  env = lib.optionalAttrs stdenv.hostPlatform.isRiscV64 {
    NIX_CFLAGS_COMPILE = "-Wno-error=cast-align";
  };

  enableParallelBuilding = true;

  postInstall = ''
    installShellCompletion --bash $out/usr/share/bash-completion/completions/*
    rm -rv $out/usr

    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://github.com/dm-vdo/vdo";
    description = "Set of userspace tools for managing pools of deduplicated and/or compressed block storage";
    # platforms need a memory fence in https://github.com/dm-vdo/vdo/blob/master/utils/uds/linux/atomic.h
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "loongarch64-linux"
      "s390-linux"
      "powerpc64-linux"
      "powerpc64le-linux"
      "riscv64-linux"
    ];
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
