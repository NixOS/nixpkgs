{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libdiscid-0.6.1";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ];

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/${name}.tar.gz";
    sha256 = "1mbd5y9056638cffpfwc6772xwrsk18prv1djsr6jpfim38jpsxc";
  };

  meta = with stdenv.lib; {
    description = "A C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = http://musicbrainz.org/doc/libdiscid;
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
