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

  patches = [
    # The upstream forgot to bump WVERSION in header before tagging `v0.0.11`.
    (fetchpatch2 {
      url = "https://github.com/endrazine/wcc/commit/4bea2dac8b49d82e4f72e42027d74fc654380f7b.patch?full_index=1";
      hash = "sha256-RK0ue8hdK/G+njwGmWpaewclRHprO8aBdZ9vBGQIQOc=";
    })
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
