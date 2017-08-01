{ stdenv, fetchgit, fetchpatch, autoreconfHook, boost, curl, openssl, log4shib, xercesc, xml-security-c }:

stdenv.mkDerivation rec {
  name = "xml-tooling-c-${version}";
  version = "1.6.0+git-2017-05-31"; # many openssl 1.1 compatibility fixes

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-xmltooling.git";
    rev = "a31cae0d2e327011e3a67a576bfdff69911bf3c5";
    sha256 = "1340j2fgkj6ai4sdnqjqfa4qf7srjn8425a25lyz7m10pxmy8ysm";
  };

  buildInputs = [ boost curl openssl log4shib xercesc xml-security-c ];
  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  postPatch = ''
    sed 's/continue$/continue;/' -i xmltooling/util/ReloadableXMLFile.cpp
  '';

  meta = with stdenv.lib; {
    description = "A low-level library that provides a high level interface to XML processing for OpenSAML 2";
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.jammerful ];
  };
}
