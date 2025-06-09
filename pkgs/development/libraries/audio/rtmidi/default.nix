{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  jackSupport ? true,
  jack,
  coremidiSupport ? stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation rec {
  pname = "rtmidi";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtmidi";
    tag = version;
    hash = "sha256-QuUeFx8rPpe0+exB3chT6dUceDa/7ygVy+cQYykq7e0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optional alsaSupport alsa-lib ++ lib.optional jackSupport jack;

  cmakeFlags = [
    "-DRTMIDI_API_ALSA=${if alsaSupport then "ON" else "OFF"}"
    "-DRTMIDI_API_JACK=${if jackSupport then "ON" else "OFF"}"
    "-DRTMIDI_API_CORE=${if coremidiSupport then "ON" else "OFF"}"
  ];

  meta = {
    description = "Set of C++ classes that provide a cross platform API for realtime MIDI input/output";
    homepage = "https://www.music.mcgill.ca/~gary/rtmidi/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.unix;
  };
}
