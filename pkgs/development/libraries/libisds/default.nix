{ stdenv
, fetchurl
, expat
, gpgme
, libgcrypt
, libxml2
, libxslt
, curl
, docbook_xsl
}:

stdenv.mkDerivation rec {
  pname = "libisds";
  version = "0.11";

  src = fetchurl {
    url = "http://xpisar.wz.cz/${pname}/dist/${pname}-${version}.tar.xz";
    sha256 = "1cy161l7rl25xji2xpb9vjpvg02bc7mwd4fpp2sx9zhpifn5dfbr";
  };

  configureFlags = [
    "--with-docbook-xsl-stylesheets=${docbook_xsl}/xml/xsl/docbook"
  ];

  buildInputs = [ expat gpgme libgcrypt libxml2 libxslt curl docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Client library for accessing SOAP services of Czech government-provided Databox infomation system";
    homepage = "http://xpisar.wz.cz/libisds/";
    license = licenses.lgpl3;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
