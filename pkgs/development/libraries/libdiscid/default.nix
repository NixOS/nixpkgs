{ stdenv, fetchurl, cmake, pkgconfig, darwin }:

stdenv.mkDerivation rec {
  pname = "libdiscid";
  version = "0.6.2";

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];
  
  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/${pname}-${version}.tar.gz";
    sha256 = "1f9irlj3dpb5gyfdnb1m4skbjvx4d4hwiz2152f83m0d9jn47r7r";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-framework CoreFoundation -framework IOKit";

  meta = with stdenv.lib; {
    description = "A C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = http://musicbrainz.org/doc/libdiscid;
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
