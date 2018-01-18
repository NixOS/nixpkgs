{ stdenv, fetchgit, autoreconfHook, boost, fcgi, openssl, opensaml-cpp, log4shib, pkgconfig, xercesc, xml-security-c, xml-tooling-c }:

stdenv.mkDerivation rec {
  name = "shibboleth-sp-${version}";
  version = "2.6.1";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-sp.git";
    rev = version;
    sha256 = "01q13p7gc0janjfml6zs46na8qnval8hc833fk2wrnmi4w9xw4fd";
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
