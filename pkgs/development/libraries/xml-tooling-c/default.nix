{ stdenv, fetchgit, autoreconfHook, boost, curl, openssl, log4shib, xercesc, xml-security-c }:

stdenv.mkDerivation rec {
  name = "xml-tooling-c-${version}";
  version = "1.6.0";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-xmltooling.git";
    rev = "db08101c3854518a59096be95ed6564838381744";
    sha256 = "0rhzvxm4z3pm28kpk34hayhm12bjjms2kygv1z68vnz8ijzgcinq";
  };

  buildInputs = [ boost curl openssl log4shib xercesc xml-security-c ];
  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A low-level library that provides a high level interface to XML processing for OpenSAML 2";
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.jammerful ];
  };
}
