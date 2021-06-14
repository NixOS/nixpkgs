{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, beautifulsoup4
, lxml
}:

buildPythonPackage rec {
  pname = "ofxparse";
  version = "unstable-2020-02-05";

  # The newer changes haven't been released yet and ledger-autosync
  # depends on them:
  src = fetchFromGitHub {
    owner = "jseutter";
    repo = "ofxparse";
    rev = "3236cfd96434feb6bc79a8b66f3400f18e2ad3c4";
    sha256 = "1rkp174102q7hwjrg3na0qnfd612xb3r360b9blkbprjhzxy7gr7";
  };

  propagatedBuildInputs = [ six beautifulsoup4 lxml ];

  meta = with lib; {
    homepage = "http://sites.google.com/site/ofxparse";
    description = "Tools for working with the OFX (Open Financial Exchange) file format";
    license = licenses.mit;
  };

}
