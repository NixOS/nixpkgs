{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  cargo,
  capstone,
  libbfd,
  libelf,
  libiberty,
  readline,
  versionCheckHook,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wcc";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "endrazine";
    repo = "wcc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hwmMj4K21xcFOmJNo96KXdG0xFeMqN9iCCkjmxGXfLs=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    capstone
    libbfd
    libelf
    libiberty
    readline
    zstd
    zlib
  ];

  patches = [
    # The upstream forgot to bump WVERSION in header before tagging `v0.0.11`.
    # Did it again in `v0.0.13` :)
    (fetchpatch2 {
      url = "https://github.com/endrazine/wcc/commit/0db1624a96e4b838bf2b0206f0b54d60c545eb7d.patch?full_index=1";
      hash = "sha256-M5urrE43b0V3jTbPUpoUU1iiPOj4mC7IMzMhoDrCfBI=";
    })
  ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    sed -i src/wsh/include/libwitch/wsh.h src/wsh/scripts/INDEX \
      -e "s#/usr/share/wcc#$out/share/wcc#"

    sed -i '/wsh-static/d' src/wsh/Makefile

    sed -i src/wcc/Makefile src/wld/Makefile \
      -e 's/:libbfd.a/bfd/' \
      -e 's/:libsframe.a/sframe/'
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  installFlags = [ "DESTDIR=$(out)" ];

  preInstall = ''
    mkdir -p $out/usr/bin $out/lib/x86_64-linux-gnu
  '';

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
    mkdir -p $out/share/man/man1
    cp doc/manpages/*.1 $out/share/man/man1/
  '';

  postFixup = ''
    # not detected by patchShebangs
    substituteInPlace $out/bin/wcch --replace-fail '#!/usr/bin/wsh' "#!$out/bin/wsh"
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/endrazine/wcc";
    description = "Witchcraft compiler collection: tools to convert and script ELF files";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      DieracDelta
    ];
    mainProgram = "wcc";
  };
})
