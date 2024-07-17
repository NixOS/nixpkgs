{
  stdenv,
  lib,
  config,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  jackSupport ? true,
  jack,
  coreaudioSupport ? stdenv.hostPlatform.isDarwin,
  CoreAudio,
}:

stdenv.mkDerivation rec {
  pname = "rtaudio";
  version = "5.2.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    rev = version;
    sha256 = "0xvahlfj3ysgsjsp53q81hayzw7f99n1g214gh7dwdr52kv2l987";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional jackSupport jack
    ++ lib.optional coreaudioSupport CoreAudio;

  cmakeFlags = [
    "-DRTAUDIO_API_ALSA=${if alsaSupport then "ON" else "OFF"}"
    "-DRTAUDIO_API_PULSE=${if pulseaudioSupport then "ON" else "OFF"}"
    "-DRTAUDIO_API_JACK=${if jackSupport then "ON" else "OFF"}"
    "-DRTAUDIO_API_CORE=${if coreaudioSupport then "ON" else "OFF"}"
  ];

  meta = with lib; {
    description = "A set of C++ classes that provide a cross platform API for realtime audio input/output";
    homepage = "https://www.music.mcgill.ca/~gary/rtaudio/";
    license = licenses.mit;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.unix;
  };
}
