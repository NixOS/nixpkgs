{ lib, stdenv, fetchgit, autoreconfHook }:

stdenv.mkDerivation {
  pname = "log4shib";
  version = "1.0.9";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-log4shib.git";
    rev = "a1afe19b7b49c32fcb03e6d72809501b8965cf85";
    sha256 = "06rrc5l6qxlc8abzim2jcxwz2c577qrjqx15cbfqq1zfqagj9hix";
  };

  nativeBuildInputs = [ autoreconfHook ];

  CXXFLAGS = "-std=c++11";

  meta = with lib; {
    description = "A forked version of log4cpp that has been created for the Shibboleth project";
    mainProgram = "log4shib-config";
    maintainers = [ ];
    license = licenses.lgpl21;
    homepage = "http://log4cpp.sf.net";
  };
}
