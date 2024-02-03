{ lib, stdenv, fetchurl, pkg-config, xapian, perl, pcre2, zlib, libmagic }:

stdenv.mkDerivation rec {
  pname = "xapian-omega";
  inherit (xapian) version;

  src = fetchurl {
    url = "https://oligarchy.co.uk/xapian/${version}/xapian-omega-${version}.tar.xz";
    hash = "sha256-Z0yXn7kPH0mQ64qQntq4jKSgCUF9/Vqwy6GeAsepVSg=";
  };

  buildInputs = [ xapian perl pcre2 zlib libmagic ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Indexer and CGI search front-end built on Xapian library";
    homepage = "https://xapian.org/";
    changelog = "https://xapian.org/docs/xapian-omega-${version}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
