{ stdenv, fetchurl, pkgconfig, xapian, perl, pcre, zlib, libmagic }:

stdenv.mkDerivation rec {
  name = "xapian-omega-${version}";
  version = (builtins.parseDrvName xapian.name).version;

  src = fetchurl {
    url = "http://oligarchy.co.uk/xapian/${version}/xapian-omega-${version}.tar.xz";
    sha256 = "07s341m1csk4v7mc44mqrzc1nxpnmdkji9k1cirbx6q0nlshdz0h";
  };

  buildInputs = [ pkgconfig xapian perl pcre zlib libmagic ];

  meta = with stdenv.lib; {
    description = "Indexer and CGI search front-end built on Xapian library";
    homepage = http://xapian.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
