{ stdenv, fetchgit, autoreconfHook, boost, fcgi, openssl, opensaml-cpp, log4shib, pkgconfig, xercesc, xml-security-c, xml-tooling-c }:

stdenv.mkDerivation rec {
  name = "shibboleth-sp-${version}";
  version = "2.6.0";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-sp.git";
    rev = "9ebba5c3a16d03769f436e383e4c4cdaa33f5509";
    sha256 = "1b5r4nd098lnjwr2g13f04ycqv5fvbrhpwg6fsdk8xy9cigvfzxj";
  };

  buildInputs = [ boost fcgi openssl opensaml-cpp log4shib pkgconfig xercesc xml-security-c xml-tooling-c ];
  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--without-apxs"
    "--with-xmltooling=${xml-tooling-c}"
    "--with-saml=${opensaml-cpp}"
    "--with-fastcgi"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = "https://shibboleth.net/products/service-provider.html";
    description = "Enables SSO and Federation web applications written with any programming language or framework";
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.jammerful ];
  };
}
