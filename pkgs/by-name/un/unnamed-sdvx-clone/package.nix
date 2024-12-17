{
  stdenv,
  cmake,
  fetchFromGitHub,
  freetype,
  pkg-config,
  SDL2,
  libpng,
  libjpeg,
  zlib,
  libogg,
  libvorbis,
  libarchive,
  iconv,
  openssl,
  curl,
  libcpr,
  rapidjson,
  writeShellScriptBin,
  makeDesktopItem,
  lib,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unnamed-sdvx-clone";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Drewol";
    repo = "unnamed-sdvx-clone";
    rev = "refs/tags/v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-wuf7xZztoxzNQJzlJOfH/Dc25/717NevBx7E0RDybho=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    freetype
    SDL2
    libpng
    libjpeg
    zlib
    libogg
    libvorbis
    libarchive
    iconv
    openssl
    curl
    libcpr
    rapidjson
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_CPR=ON"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  # Wrapper script because the things are hardcoded so we just
  # change the game directory via the built in option uhhhhh
  wrapperScript = writeShellScriptBin "usc-game-wrapped" ''
    DATA_PATH="''${XDG_CONFIG_HOME:-$HOME/.local/share}/usc"
    mkdir -p $DATA_PATH

    cp -r @out@/bin/audio $DATA_PATH
    cp -r @out@/bin/fonts $DATA_PATH
    cp -r @out@/bin/skins $DATA_PATH
    cp -r @out@/bin/LightPlugins $DATA_PATH

    find $DATA_PATH -type d -exec chmod 755 {} +
    find $DATA_PATH -type f -exec chmod 644 {} +

    @out@/bin/usc-game -gamedir="$DATA_PATH"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Unnamed SDVX Clone";
      exec = "usc-game-wrapped";
      comment = "Unnamed SDVX Clone";
      desktopName = "Unnamed SDVX Clone";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    substituteAll $wrapperScript/bin/usc-game-wrapped $out/bin/usc-game-wrapped
    chmod +x $out/bin/usc-game-wrapped
    mkdir $out/share
    cp -r /build/source/bin $out
    runHook postInstall
  '';

  meta = {
    description = "A game based on K-Shoot MANIA and Sound Voltex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sako ];
    platforms = lib.platforms.linux;
    mainProgram = "usc-game-wrapped";
  };
})
