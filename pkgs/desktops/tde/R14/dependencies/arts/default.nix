{ stdenv, fetchurl, pkgconfig, cmake
, glib, pcre, libtool, libogg, libvorbis
, tde
, audiofileSupport ? true, audiofile ? null
, lameSupport ? true, lame ? null
, libmadSupport ? true, libmad ? null
, libmp3spltSupport ? true, libmp3splt ? null
, mpdSupport ? true, mpd ? null
, vorbisToolsSupport ? true, vorbisTools ? null
, alsaSupport ? true, alsaLib ? null
, jack2Support ? true, jack2Full ? null
}:

assert audiofileSupport   -> (audiofile != null);
assert lameSupport        -> (lame != null);
assert libmadSupport      -> (libmad != null);
assert libmp3spltSupport  -> (libmp3splt != null);
assert mpdSupport         -> (mpd != null);
assert vorbisToolsSupport -> (vorbisTools != null);
assert alsaSupport        -> (alsaLib != null);
assert jack2Support       -> (jack2Full != null);

let baseName = "arts"; in
with stdenv.lib;
stdenv.mkDerivation rec {

  name = "${baseName}-${version}";
  srcName = "${baseName}-R${version}";
  version = "${majorVer}.${minorVer}.${patchVer}";
  majorVer = "14";
  minorVer = "0";
  patchVer = "4";

  src = fetchurl {
    url = "mirror://tde/R${version}/dependencies/${srcName}.tar.bz2";
    sha256 = "13x5bk093yxr96br1x8wd0a5s00ikjvsmwz6agwmc667sw0a290v";
  };

  nativeBuildInputs = [ pkgconfig cmake libtool ];
  buildInputs = [ glib pcre ];
  propagatedBuildInputs = [ libogg libvorbis tde.tqtinterface ]
    ++ optional audiofileSupport audiofile
    ++ optional lameSupport lame
    ++ optional libmadSupport libmad
    ++ optional libmp3spltSupport libmp3splt
    ++ optional mpdSupport mpd
    ++ optional vorbisToolsSupport vorbisTools
    ++ optional alsaSupport alsaLib
    ++ optional jack2Support jack2Full;

  cmakeFlags = ''
    -DWITH_ALSA=${if alsaSupport then "ON" else "OFF"}
    -DWITH_AUDIOFILE=${if audiofileSupport then "ON" else "OFF"}
    -DWITH_LIBJACK=${if jack2Support then "ON" else "OFF"}
    -DWITH_MAD=${if libmadSupport then "ON" else "OFF"}
    -DWITH_SNDIO=OFF
    -DWITH_ESOUND=OFF
    -DWITH_VORBIS=ON
  '';

  preConfigure = ''
    cd ${baseName}
  '';

  # It doesn't find libmcop.so library without that 'hack'
  postConfigure = ''
    export LD_LIBRARY_PATH=$(pwd)/mcop:$LD_LIBRARY_PATH
  '';

  meta = with stdenv.lib;{
    description = "Analog Real-Time Synthesizer";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: investigate about Audio-Convert tool
# TODO: investigate about jack
