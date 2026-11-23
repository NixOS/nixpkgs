{
  alsa-lib,
  cmake,
  curl,
  fetchFromGitHub,
  fontconfig,
  freetype,
  lib,
  libGL,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  libjack2,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "uhhyou-plugins-juce";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "ryukau";
    repo = "UhhyouPluginsJuce";
    tag = "UhhyouPluginsJuce${finalAttrs.version}";
    hash = "sha256-arMXVzS2niKN3Wa2GTHuOHP3VoQ4ng/smBqkDsJ0R6I=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    alsa-lib
    curl
    fontconfig
    freetype
    libGL
    libxcursor
    libxext
    libxinerama
    libxrandr
    libjack2
  ];

  # Disable LTO to avoid optimization mismatch issues
  env.NIX_CFLAGS_COMPILE = toString [
    "-fno-lto"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3
    find . -type d -name '*.vst3' -exec cp -r {} $out/lib/vst3/ \;

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ryukau/UhhyouPluginsJuce";
    description = "A collection of VST3 effect plugins";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
