{ lib
, stdenv
, tde
, alsa-lib
, audiofile
, cmake
, glib
, jack2
, lame
, libmad
, libmp3splt
, libogg
, libtool
, libvorbis
, mpd
, pcre
, pkg-config
, vorbis-tools

, alsaSupport ? stdenv.isLinux
, audiofileSupport ? true
, jack2Support ? true
, lameSupport ? true
, libmadSupport ? true
, libmp3spltSupport ? true
, mpdSupport ? true
, vorbisSupport ? true
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (tde.mkTDEComponent tde.sources.arts)
    pname version src;

  nativeBuildInputs = [
    cmake
    libtool
    pkg-config
    tde.tde-cmake
  ];

  buildInputs = [
    tde.tqtinterface
    glib
    libogg
    libvorbis
    pcre
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional audiofileSupport audiofile
  ++ lib.optional jack2Support jack2
  ++ lib.optional lameSupport lame
  ++ lib.optional libmadSupport libmad
  ++ lib.optional libmp3spltSupport libmp3splt
  ++ lib.optional mpdSupport mpd
  ++ lib.optional vorbisSupport vorbis-tools
  ;

  cmakeFlags = [
    (lib.cmakeBool "WITH_ALSA" alsaSupport)
    (lib.cmakeBool "WITH_AUDIOFILE" audiofileSupport)
    (lib.cmakeBool "WITH_ESOUND" false)
    (lib.cmakeBool "WITH_LIBJACK" jack2Support)
    (lib.cmakeBool "WITH_MAD" libmadSupport)
    (lib.cmakeBool "WITH_SNDIO" false)
    (lib.cmakeBool "WITH_VORBIS" vorbisSupport)
  ];

  meta = (tde.mkTDEComponent tde.sources.arts).meta;
})
