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
  CoreMIDI,
  CoreAudio,
  CoreServices,
}:

stdenv.mkDerivation rec {
  pname = "rtmidi";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtmidi";
    rev = version;
    sha256 = "1r1sqmdi499zfh6z6kjkab6d4a7kz3il5kkcdfz9saa6ry992211";
  };

  patches = [
    # Remove when https://github.com/thestk/rtmidi/pull/278 merged
    (fetchpatch {
      name = "0001-rtmidi-Use-posix-sched_yield-instead-of-pthread_yield.patch";
      url = "https://github.com/thestk/rtmidi/pull/278/commits/cfe34c02112c256235b62b45895fc2c401fd874d.patch";
      sha256 = "0yzq7zbdkl5r4i0r6vy2kq986cqdxz2cpzb7s977mvh09kdikrw1";
    })
    # Remove when https://github.com/thestk/rtmidi/pull/277 merged
    (fetchpatch {
      name = "0002-rtmidi-include-TargetConditionals.h-on-Apple-platforms.patch";
      url = "https://github.com/thestk/rtmidi/pull/277/commits/9d863beb28f03ec53f3e4c22cc0d3c34a1e1789b.patch";
      sha256 = "1hlrg23c1ycnwdvxpic8wvypiril04rlph0g820qn1naf92imfjg";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    lib.optional alsaSupport alsa-lib
    ++ lib.optional jackSupport jack
    ++ lib.optionals coremidiSupport [
      CoreMIDI
      CoreAudio
      CoreServices
    ];

  cmakeFlags = [
    "-DRTMIDI_API_ALSA=${if alsaSupport then "ON" else "OFF"}"
    "-DRTMIDI_API_JACK=${if jackSupport then "ON" else "OFF"}"
    "-DRTMIDI_API_CORE=${if coremidiSupport then "ON" else "OFF"}"
  ];

  meta = with lib; {
    description = "A set of C++ classes that provide a cross platform API for realtime MIDI input/output";
    homepage = "https://www.music.mcgill.ca/~gary/rtmidi/";
    license = licenses.mit;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.unix;
  };
}
