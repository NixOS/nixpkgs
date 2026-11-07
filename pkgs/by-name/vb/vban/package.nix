{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  libpulseaudio,
  libjack2,
  alsaSupport ? true,
  pulseSupport ? config.pulseaudio or true,
  jackSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vban";
  version = "2024-02-04";

  src = fetchFromGitHub {
    owner = "KarolKozlowski";
    repo = "vban";
    rev = "c11b3c002086d06538a70e8d5877c2d4bcd5ae65";
    sha256 = "sha256-KH8ykBO7DHWhQCssIxfIzzIwG1hVpkFPYbA3zZ4XTRs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional jackSupport libjack2;

  cmakeFlags = [
    (lib.cmakeBool "WITH_ALSA" alsaSupport)
    (lib.cmakeBool "WITH_PULSEAUDIO" pulseSupport)
    (lib.cmakeBool "WITH_JACK" jackSupport)
  ];

  meta = {
    description = "Linux command-line VBAN tools";
    homepage = "https://github.com/KarolKozlowski/vban";
    maintainers = with lib.maintainers; [ ch4og ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
