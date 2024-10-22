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
  onOff = val: if val then "ON" else "OFF";
in
stdenv.mkDerivation {
  pname = "libvgm";
  version = "0-unstable-2024-06-08";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "libvgm";
    rev = "34c368cde98f33c42455fbbfbec07073ba79bf5c";
    hash = "sha256-eX2k2cUtapHhx8dLaFk63Si0Di1q0uDWvdOI0+FgqEY=";
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
    "-DBUILD_LIBAUDIO=${onOff enableAudio}"
    "-DBUILD_LIBEMU=${onOff enableEmulation}"
    "-DBUILD_LIBPLAYER=${onOff enableLibplayer}"
    "-DBUILD_TESTS=${onOff enableTools}"
    "-DBUILD_PLAYER=${onOff enableTools}"
    "-DBUILD_VGM2WAV=${onOff enableTools}"
    "-DLIBRARY_TYPE=${if enableShared then "SHARED" else "STATIC"}"
    "-DUSE_SANITIZERS=ON"
  ] ++ optionals enableAudio [
    "-DAUDIODRV_WAVEWRITE=${onOff withWaveWrite}"
    "-DAUDIODRV_WINMM=${onOff withWinMM}"
    "-DAUDIODRV_DSOUND=${onOff withDirectSound}"
    "-DAUDIODRV_XAUDIO2=${onOff withXAudio2}"
    "-DAUDIODRV_WASAPI=${onOff withWASAPI}"
    "-DAUDIODRV_OSS=${onOff withOSS}"
    "-DAUDIODRV_SADA=${onOff withSADA}"
    "-DAUDIODRV_ALSA=${onOff withALSA}"
    "-DAUDIODRV_PULSE=${onOff withPulseAudio}"
    "-DAUDIODRV_APPLE=${onOff withCoreAudio}"
    "-DAUDIODRV_LIBAO=${onOff withLibao}"
  ] ++ optionals enableEmulation ([
    "-DSNDEMU__ALL=${onOff withAllEmulators}"
  ] ++ optionals (!withAllEmulators)
    (lib.lists.forEach emulators (x: "-DSNDEMU_${x}=ON"))
  ) ++ optionals enableTools [
    "-DUTIL_CHARCNV_ICONV=ON"
    "-DUTIL_CHARCNV_WINAPI=${onOff stdenv.hostPlatform.isWindows}"
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
