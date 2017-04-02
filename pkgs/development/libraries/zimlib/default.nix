{ stdenv, fetchurl, lzma }:

stdenv.mkDerivation rec {
  name = "zimlib-${version}";
  version = "1.4";

  src = fetchurl {
    url = "http://www.openzim.org/download/${name}.tar.gz";
    sha256 = "14ra3iq42x53k1nqxb5lsg4gadlkpkgv6cbjjl6305ajmbrghcdq";
  };

  buildInputs = [ lzma ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for reading and writing ZIM files";
    homepage =  http://www.openzim.org/wiki/Zimlib;
    license = licenses.gpl2;
    maintainers = with maintainers; [ robbinch ];
    platforms = platforms.linux;
  };
}
