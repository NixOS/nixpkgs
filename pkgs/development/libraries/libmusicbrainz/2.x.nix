{ stdenv, fetchurl, expat }:

stdenv.mkDerivation rec {
  name = "libmusicbrainz-2.1.5";

  configureFlags = "--enable-cpp-headers";

  buildInputs = [ expat ];

  patches = [ ./gcc-4.x.patch ];

  src = fetchurl {
    url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/${name}.tar.gz";
    sha256 = "183i4c109r5qx3mk4r986sx5xw4n5mdhdz4yz3rrv3s2xm5rqqn6";
  };
}
