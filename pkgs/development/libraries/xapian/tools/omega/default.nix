{ stdenv, fetchurl, pkgconfig, xapian, perl, pcre, zlib, libmagic }:

stdenv.mkDerivation rec {
  pname = "xapian-omega";
  inherit (xapian) version;

  src = fetchurl {
    url = "https://oligarchy.co.uk/xapian/${version}/xapian-omega-${version}.tar.xz";
    sha256 = "0zji8ckp4h5xdy2wbir3lvk680w1g1l4h5swmaxsx7ah12lkrjcr";
  };

  buildInputs = [ xapian perl pcre zlib libmagic ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Indexer and CGI search front-end built on Xapian library";
    homepage = "https://xapian.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
