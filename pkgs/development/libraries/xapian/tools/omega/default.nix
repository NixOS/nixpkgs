{ lib, stdenv, fetchurl, pkg-config, xapian, perl, pcre2, zlib, libmagic }:

stdenv.mkDerivation rec {
  pname = "xapian-omega";
  inherit (xapian) version;

  src = fetchurl {
    url = "https://oligarchy.co.uk/xapian/${version}/xapian-omega-${version}.tar.xz";
    hash = "sha256-pbI4bhsE34TRFJqenFvPxeRyammmnaZBuGxo15ln2uQ=";
  };

  buildInputs = [ xapian perl pcre2 zlib libmagic ];
  nativeBuildInputs = [ pkg-config ];

  postInstall = ''
    mkdir -p $out/share/omega
    cp -r templates $out/share/omega
  '';

  meta = with lib; {
    description = "Indexer and CGI search front-end built on Xapian library";
    homepage = "https://xapian.org/";
    changelog = "https://xapian.org/docs/xapian-omega-${version}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
