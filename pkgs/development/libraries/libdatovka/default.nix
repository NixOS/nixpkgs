{ lib
, stdenv
, autoreconfHook
, pkg-config
, fetchurl
, expat
, gpgme
, libgcrypt
, libxml2
, libxslt
, gnutls
, curl
, docbook_xsl
}:

stdenv.mkDerivation rec {
  pname = "libdatovka";
  version = "0.2.1";

  src = fetchurl {
    url = "https://gitlab.nic.cz/datovka/libdatovka/-/archive/v${version}/libdatovka-v${version}.tar.gz";
    sha256 = "sha256-687d8ZD9zfMeo62YWCW5Kc0CXkKClxtbbwXR51pPwBE=";
  };

  patches = [
    ./libdatovka-deprecated-fn-curl.patch
  ];

  configureFlags = [
    "--with-docbook-xsl-stylesheets=${docbook_xsl}/xml/xsl/docbook"
  ];

  buildInputs = [ pkg-config autoreconfHook expat gpgme libgcrypt libxml2 libxslt gnutls curl docbook_xsl ];

  meta = with lib; {
    description = "Client library for accessing SOAP services of Czech government-provided Databox infomation system";
    homepage = "https://gitlab.nic.cz/datovka/libdatovka";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.ovlach ];
    platforms = platforms.linux;
  };
}
