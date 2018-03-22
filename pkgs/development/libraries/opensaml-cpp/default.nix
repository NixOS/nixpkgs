{ stdenv, fetchgit, autoreconfHook, boost, openssl, log4shib, xercesc, xml-security-c, xml-tooling-c, zlib }:

stdenv.mkDerivation rec {
  name = "opensaml-cpp-${version}";
  version = "2.6.1";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-opensaml.git";
    rev = version;
    sha256 = "0wjb6jyvh4hwpy1pvhh63i821746nqijysrd4vasbirkf4h6z7nx";
  };

  buildInputs = [ boost openssl log4shib xercesc xml-security-c xml-tooling-c zlib ];
  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--with-xmltooling=${xml-tooling-c}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = "https://shibboleth.net/products/opensaml-cpp.html";
    description = "A low-level library written in C++ that provides support for producing and consuming SAML messages";
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.jammerful ];
  };
}
