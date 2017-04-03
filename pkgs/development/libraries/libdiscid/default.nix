{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libdiscid-${version}";
  version = "0.6.2";

  nativeBuildInputs = [ cmake pkgconfig ];
  
  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/${name}.tar.gz";
    sha256 = "1f9irlj3dpb5gyfdnb1m4skbjvx4d4hwiz2152f83m0d9jn47r7r";
  };

  meta = with stdenv.lib; {
    description = "A C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = http://musicbrainz.org/doc/libdiscid;
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
