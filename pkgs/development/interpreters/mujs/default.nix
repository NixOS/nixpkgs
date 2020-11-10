{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  pname = "mujs";
  version = "1.0.7";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.xz";
    sha256 = "1ilhay15z4k7mlzs6g2d00snivin7vp72dfw5wwpmc0x70jr31l2";
  };

  buildInputs = [ readline ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://mujs.com/";
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
