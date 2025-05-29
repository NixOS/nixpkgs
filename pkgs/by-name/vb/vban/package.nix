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
  version = "2020-10-11";

  src = fetchFromGitHub {
    owner = "quiniouben";
    repo = "vban";
    rev = "4f69e5a6cd02627a891f2b15c2cf01bf4c87d23d";
    sha256 = "sha256-V7f+jcj3NpxXNr15Ozx2is4ReeeVpl3xvelMuPNfNT0=";
  };

  nativeBuildInputs =
    [
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
    homepage = "https://github.com/quiniouben/vban";
    maintainers = with lib.maintainers; [ ch4og ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
