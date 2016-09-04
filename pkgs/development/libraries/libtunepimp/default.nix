{ stdenv, fetchurl, zlib, expat, curl, libmusicbrainz2, taglib, libmpcdec,
  libmad, libogg, libvorbis, flac, mp4v2, libofa, libtool }:

stdenv.mkDerivation rec {
  name = "libtunepimp-0.5.3";

  propagatedBuildInputs = [ zlib expat curl libmusicbrainz2 taglib libmpcdec
    libmad libogg libvorbis flac libofa libtool ];

  patches = [ ./gcc-4.x.patch ];

  src = fetchurl {
    url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/${name}.tar.gz";
    sha256 = "0s141zmsxv8xlivcgcmy6xhk9cyjjxmr1fy45xiqfqrqpsh485rl";
  };

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
