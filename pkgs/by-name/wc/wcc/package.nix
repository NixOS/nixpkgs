{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo,
  capstone,
  libbfd,
  libelf,
  libiberty,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wcc";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "endrazine";
    repo = "wcc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cg8rf8R3xYNJTJhrDfIdVAUR/OOd6JjB0NYHRosUzvU=";
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
  ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    sed -i src/wsh/include/libwitch/wsh.h src/wsh/scripts/INDEX \
      -e "s#/usr/share/wcc#$out/share/wcc#"

    sed -i -e '/stropts.h>/d' src/wsh/include/libwitch/wsh.h

    sed -i '/wsh-static/d' src/wsh/Makefile
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

  meta = {
    homepage = "https://github.com/endrazine/wcc";
    description = "Witchcraft compiler collection: tools to convert and script ELF files";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      orivej
      DieracDelta
    ];
    mainProgram = "wcc";
  };
})
