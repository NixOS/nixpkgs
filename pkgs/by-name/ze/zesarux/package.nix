{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  aalib,
  alsa-lib,
  libxext,
  libxxf86vm,
  libcaca,
  libpulseaudio,
  libsndfile,
  ncurses,
  openssl,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zesarux";
  version = "12.1";

  src = fetchFromGitHub {
    owner = "chernandezba";
    repo = "zesarux";
    tag = "ZEsarUX-${finalAttrs.version}";
    hash = "sha256-899+n55+Sa+TqnQBH/kyhEIcIr/4pGZ3ekWgXb9NVOo=";
  };

  nativeBuildInputs = [
    which
  ];

  buildInputs = [
    SDL2
    aalib
    alsa-lib
    libxxf86vm
    libxext
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
    mainProgram = "zesarux";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
