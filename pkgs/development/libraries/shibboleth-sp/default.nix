{ stdenv, fetchgit, autoreconfHook, boost, fcgi, openssl, opensaml-cpp, log4shib, pkgconfig, xercesc, xml-security-c, xml-tooling-c }:

stdenv.mkDerivation rec {
  pname = "shibboleth-sp";
  version = "3.0.4.1";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-sp.git";
    rev = version;
    sha256 = "1qb4dbz5gk10b9w1rf6f4vv7c2wb3a8bfzif6yiaq96ilqad7gdr";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ boost fcgi openssl opensaml-cpp log4shib xercesc xml-security-c xml-tooling-c ];

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
