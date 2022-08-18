{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, cmake
, libiconv
, zlib
, enableShared ? true

, enableAudio ? true
, withWaveWrite ? true
, withWinMM ? stdenv.hostPlatform.isWindows
, withDirectSound ? stdenv.hostPlatform.isWindows
, withXAudio2 ? stdenv.hostPlatform.isWindows
, withWASAPI ? stdenv.hostPlatform.isWindows
, withOSS ? stdenv.hostPlatform.isFreeBSD
, withSADA ? stdenv.hostPlatform.isSunOS
, withALSA ? stdenv.hostPlatform.isLinux
, alsa-lib
, withPulseAudio ? stdenv.hostPlatform.isLinux
, libpulseaudio
, withCoreAudio ? stdenv.hostPlatform.isDarwin
, CoreAudio
, AudioToolbox
, withLibao ? true
, libao

, enableEmulation ? true
, withAllEmulators ? true
, emulators ? [ ]

, enableLibplayer ? true

, enableTools ? false
}:

assert enableTools -> enableAudio && enableEmulation && enableLibplayer;

let
  inherit (lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "libvgm";
  version = "unstable-2022-06-18";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "libvgm";
    rev = "001ca758538ca3f82403dff654d82342730b215d";
    sha256 = "O3jvEEW1M0cwZoG6j2ndmuQW4jP0dvt6gGp2BS4VD5s=";
  };

  outputs = [
    "out"
    "dev"
  ] ++ optional enableTools "bin";

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    libiconv
    zlib
  ] ++ optionals withALSA [
    alsa-lib
  ] ++ optionals withPulseAudio [
    libpulseaudio
  ] ++ optionals withCoreAudio [
    CoreAudio
    AudioToolbox
  ] ++ optionals withLibao [
    libao
  ];

  cmakeFlags = [
    "-DBUILD_LIBAUDIO=${lib.boolToCMakeString enableAudio}"
    "-DBUILD_LIBEMU=${lib.boolToCMakeString enableEmulation}"
    "-DBUILD_LIBPLAYER=${lib.boolToCMakeString enableLibplayer}"
    "-DBUILD_TESTS=${lib.boolToCMakeString enableTools}"
    "-DBUILD_PLAYER=${lib.boolToCMakeString enableTools}"
    "-DBUILD_VGM2WAV=${lib.boolToCMakeString enableTools}"
    "-DLIBRARY_TYPE=${if enableShared then "SHARED" else "STATIC"}"
    "-DUSE_SANITIZERS=ON"
  ] ++ optionals enableAudio [
    "-DAUDIODRV_WAVEWRITE=${lib.boolToCMakeString withWaveWrite}"
    "-DAUDIODRV_WINMM=${lib.boolToCMakeString withWinMM}"
    "-DAUDIODRV_DSOUND=${lib.boolToCMakeString withDirectSound}"
    "-DAUDIODRV_XAUDIO2=${lib.boolToCMakeString withXAudio2}"
    "-DAUDIODRV_WASAPI=${lib.boolToCMakeString withWASAPI}"
    "-DAUDIODRV_OSS=${lib.boolToCMakeString withOSS}"
    "-DAUDIODRV_SADA=${lib.boolToCMakeString withSADA}"
    "-DAUDIODRV_ALSA=${lib.boolToCMakeString withALSA}"
    "-DAUDIODRV_PULSE=${lib.boolToCMakeString withPulseAudio}"
    "-DAUDIODRV_APPLE=${lib.boolToCMakeString withCoreAudio}"
    "-DAUDIODRV_LIBAO=${lib.boolToCMakeString withLibao}"
  ] ++ optionals enableEmulation ([
    "-DSNDEMU__ALL=${lib.boolToCMakeString withAllEmulators}"
  ] ++ optionals (!withAllEmulators)
    (lib.lists.forEach emulators (x: "-DSNDEMU_${x}=ON"))
  ) ++ optionals enableTools [
    "-DUTIL_CHARCNV_ICONV=ON"
    "-DUTIL_CHARCNV_WINAPI=${lib.boolToCMakeString stdenv.hostPlatform.isWindows}"
  ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/ValleyBell/libvgm.git";
  };

  meta = with lib; {
    homepage = "https://github.com/ValleyBell/libvgm";
    description = "More modular rewrite of most components from VGMPlay";
    license =
      if (enableEmulation && (withAllEmulators || (lib.lists.any (core: core == "WSWAN_ALL") emulators))) then
        licenses.unfree # https://github.com/ValleyBell/libvgm/issues/43
      else
        licenses.gpl2Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
