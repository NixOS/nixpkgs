{
  alsa-lib,
  cmake,
  curl,
  fetchFromGitHub,
  freetype,
  lib,
  libGL,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libjack2,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "uhhyou-plugins-juce";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "ryukau";
    repo = "UhhyouPluginsJuce";
    tag = "UhhyouPluginsJuce${finalAttrs.version}";
    hash = "sha256-oHxyOTiqEwdNUKGQNjjfdRkzMa+4TYX6Vf6ZS9BTcC0=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    alsa-lib
    curl
    freetype
    libGL
    libXcursor
    libXext
    libXinerama
    libXrandr
    libjack2
  ];

  # Disable LTO to avoid optimization mismatch issues
  NIX_CFLAGS_COMPILE = [
    "-fno-lto"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3
    cp -r *_artefacts/Release/VST3/*.vst3 $out/lib/vst3/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ryukau/UhhyouPluginsJuce";
    description = "A collection of VST3 effect plugins";
    license = [ lib.licenses.agpl3Only ];
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
