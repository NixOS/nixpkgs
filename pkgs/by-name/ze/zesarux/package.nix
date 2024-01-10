{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, SDL2
, aalib
, alsa-lib
, libXext
, libXxf86vm
, libcaca
, libpulseaudio
, libsndfile
, ncurses
, openssl
, which
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zesarux";
  version = "unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "chernandezba";
    repo = "zesarux";
    rev = "02e734b088c3b880b2d260a9812404f029dfc92a";
    hash = "sha256-1PWFpUNekDKyCUNuV/cNUZ7hWGZBMu0nxswD6pap8pg=";
  };

  nativeBuildInputs = [
    which
  ];

  buildInputs = [
    SDL2
    aalib
    alsa-lib
    libXxf86vm
    libXext
    libcaca
    libpulseaudio
    libsndfile
    ncurses
    openssl
  ];

  strictDeps = true;

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    patchShebangs *.sh
  '';

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--c-compiler ${stdenv.cc.targetPrefix}cc"
    "--enable-cpustats"
    "--enable-memptr"
    "--enable-sdl2"
    "--enable-ssl"
    "--enable-undoc-scfccf"
    "--enable-visualmem"
  ];

  installPhase = ''
    runHook preInstall

    ./generate_install_sh.sh
    patchShebangs ./install.sh
    ./install.sh

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/chernandezba/zesarux";
    description = "ZX Second-Emulator And Released for UniX";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
