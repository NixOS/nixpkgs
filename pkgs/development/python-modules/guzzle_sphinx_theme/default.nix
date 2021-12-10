{ lib, buildPythonPackage, sphinx, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "guzzle_sphinx_theme";
  version = "0.7.11";
  src = fetchFromGitHub {
     owner = "guzzle";
     repo = "guzzle_sphinx_theme";
     rev = "0.7.11";
     sha256 = "18mgk1rl1345zf9i7nihfw2mr609ylxcksrklyz6m2xbh19bbrja";
  };

  doCheck = false; # no tests

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "Sphinx theme used by Guzzle: http://guzzlephp.org";
    homepage = "https://github.com/guzzle/guzzle_sphinx_theme/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
    platforms = platforms.unix;
  };
}
