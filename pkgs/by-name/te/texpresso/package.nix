{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

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
  version = "0.1-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "texpresso";
    rev = "e8df7709077b2f86f6e16e6c86ceefb86de06f8d";
    hash = "sha256-ijQwoQIJ6CsAd7eY9kkK2aHO/5FRFP5/tE6H9R/pngY=";
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
  __structuredAttrs = true;

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

  passthru.updateScript = unstableGitUpdater {
    branch = "main";
    tagPrefix = "v";
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
    # no changelog for unstable version; change to
    # https://github.com/let-def/texpresso/blob/${finalAttrs.version}/CHANGELOG.md
    # once stable again
    changelog = "https://github.com/let-def/texpresso/blob/main/CHANGELOG.md";
    mainProgram = "texpresso";
    maintainers = with lib.maintainers; [
      nickhu
      stephen-huan
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
