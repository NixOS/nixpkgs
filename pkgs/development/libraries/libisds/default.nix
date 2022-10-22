{ lib, stdenv
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
  version = "0.11.2";

  src = fetchurl {
    url = "http://xpisar.wz.cz/${pname}/dist/${pname}-${version}.tar.xz";
    sha256 = "sha256-YUb4N7J7EaYHHiFI965kUhtNitRTJfmY/ns3MTfkGPs=";
  };

  configureFlags = [
    "--with-docbook-xsl-stylesheets=${docbook_xsl}/xml/xsl/docbook"
  ];

  buildInputs = [ expat gpgme libgcrypt libxml2 libxslt curl docbook_xsl ];

  meta = with lib; {
    description = "Client library for accessing SOAP services of Czech government-provided Databox infomation system";
    homepage = "http://xpisar.wz.cz/libisds/";
    license = licenses.lgpl3;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
