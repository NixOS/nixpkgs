{ stdenv, fetchurl, pkgconfig, xapian, perl, pcre, zlib, libmagic }:

stdenv.mkDerivation rec {
  name = "xapian-omega-${version}";
  inherit (xapian) version;

  src = fetchurl {
    url = "http://oligarchy.co.uk/xapian/${version}/xapian-omega-${version}.tar.xz";
    sha256 = "0pl9gs0sbavxykfgrkm8syswqnfynmmqhf8429bv8a5qjh5pkp8l";
  };

  buildInputs = [ xapian perl pcre zlib libmagic ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Indexer and CGI search front-end built on Xapian library";
    homepage = http://xapian.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
