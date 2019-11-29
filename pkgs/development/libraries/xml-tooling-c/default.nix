{ stdenv, fetchgit, autoreconfHook, pkgconfig
, boost, curl, openssl, log4shib, xercesc, xml-security-c
}:

stdenv.mkDerivation rec {
  pname = "xml-tooling-c";
  version = "3.0.4";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-xmltooling.git";
    rev = version;
    sha256 = "0frj4w70l06nva6dvdcivgm1ax69rqbjdzzbgp0sxhiqhddslbas";
  };

  buildInputs = [ boost curl openssl log4shib xercesc xml-security-c ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A low-level library that provides a high level interface to XML processing for OpenSAML 2";
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.jammerful ];
  };
}
