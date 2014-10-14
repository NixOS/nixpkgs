{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "id3lib-3.8.3";

  patches = [ ./id3lib-3.8.3-gcc43-1.patch ];

  buildInputs = [ zlib ];
  
  src = fetchurl {
    url = mirror://sourceforge/id3lib/id3lib-3.8.3.tar.gz;
    sha256 = "0yfhqwk0w8q2hyv1jib1008jvzmwlpsxvc8qjllhna6p1hycqj97";
  };
}
