{ stdenv, fetchurl, pkgconfig, cmake
, glib, pcre, libtool, libogg, libvorbis
, tqtinterface
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
assert jack2Support     -> (jack2Full != null);

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "arts-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14.0";
  minorVer = "3";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${name}.tar.bz2";
    sha256 = "0hh7gkyi5q6r5siz41fr5557zqgxlqja9c8yzyxvq2hgsrdh4883";
  };

  buildInputs = [ pkgconfig cmake libtool glib pcre ];
  propagatedBuildInputs = [ libogg libvorbis tqtinterface ]
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
    cd arts
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
