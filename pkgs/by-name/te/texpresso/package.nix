{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  makeWrapper,
  pkg-config,
  writeShellScriptBin,

  # buildInputs
  fontconfig,
  freetype,
  harfbuzz,
  icu,
  jbig2dec,
  libjpeg,
  mupdf,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texpresso";
  version = "0.1-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "texpresso";
    rev = "96f008c94ece067fac8e896d0ab1808c948a4dd3";
    hash = "sha256-ew7n3Sp4uYLv5jijRW2rRM9s63TQCeFgKXmmBXdYjx4=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "CC=gcc" "CC=${stdenv.cc.targetPrefix}cc" \
      --replace-fail "LDCC=g++" "LDCC=${stdenv.cc.targetPrefix}c++"
    substituteInPlace src/engine/Makefile \
      --replace-fail "_CC?=gcc" "_CC?=${stdenv.cc.targetPrefix}cc" \
      --replace-fail "_LD?=g++" "_LD?=${stdenv.cc.targetPrefix}c++" \
      --replace-fail "_CXX?=g++" "_CXX?=${stdenv.cc.targetPrefix}c++"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    # Especially for Darwin builds, we pretend we are Linux to avoid upstream's
    # makefiles from using brew.
    (writeShellScriptBin "uname" "echo Linux")
  ];

  buildInputs = [
    fontconfig
    freetype
    harfbuzz
    icu
    jbig2dec
    libjpeg
    mupdf
    SDL2
  ];

  buildFlags = [
    "texpresso"
    "texpresso-xetex"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
    ];
  };

  installPhase = ''
    runHook preInstall
    install -D -t "$out/bin/" "build/texpresso"
    install -D -t "$out/bin/" "build/texpresso-xetex"
    runHook postInstall
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Live rendering and error reporting for LaTeX";
    maintainers = with lib.maintainers; [ nickhu ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
