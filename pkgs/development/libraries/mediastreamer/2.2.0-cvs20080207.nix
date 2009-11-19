{ stdenv, fetchurl, autoconf, automake, libtool
, pkgconfig, alsaLib, ffmpeg, speex, ortp }:

stdenv.mkDerivation rec {
  name = "mediastreamer2-2.2.0-cvs20080207";

# This url is not related to mediastreamer. fetchcvs doesn't work on my laptop,
# so I've created cvs snapshot and put it to my server.
  src = fetchurl {
    url = "http://www.loegria.net/misc/" + name + ".tar.bz2";
    sha256 = "1nmvyqh4x3nsw4qbj754jwagj9ia183kvp8valdr7m44my0sw5p1";
  };

  buildInputs = [automake libtool autoconf pkgconfig];

  propagatedBuildInputs = [alsaLib ffmpeg speex ortp];

  preConfigure = "./autogen.sh";

  patches = [ ./h264.patch ./plugins.patch ];

  configureFlags = "--enable-external-ortp";
}
