{ stdenv, fetchgit, autoreconfHook, boost, curl, openssl, log4shib, xercesc, xml-security-c }:

stdenv.mkDerivation rec {
  name = "xml-tooling-c-${version}";
  version = "1.6.3";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-xmltooling.git";
    rev = version;
    sha256 = "09z2pp3yy3kqx22vwgxyi3s0vlpdv9camw8dpi3q8piff6zxak3q";
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
