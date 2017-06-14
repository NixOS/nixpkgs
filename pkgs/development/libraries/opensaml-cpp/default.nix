{ stdenv, fetchgit, autoreconfHook, boost, openssl, log4shib, xercesc, xml-security-c, xml-tooling-c, zlib }:

stdenv.mkDerivation rec {
  name = "opensaml-cpp-${version}";
  version = "2.6.0";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-opensaml.git";
    rev = "61193de29e4c9f1ccff7ed7e1f42c2748c62be77";
    sha256 = "1jlxa1f2qn0kd15fzjqp80apxn42v47wg3mx1vk424m31rhi00xr";
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
