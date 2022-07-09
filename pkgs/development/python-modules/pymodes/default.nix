{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytest
, numpy
, pyzmq }:

buildPythonPackage rec {
  pname = "pymodes";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "junzis";
    repo = "pyModeS";
    rev = "b36540e2a17c49bf36bc824bc1e4488306d1a1a0";
    sha256 = "1j8brmiz0pqiv9zy2fxg1w65n9pzfnbag54mqkg5yrvz25b93nba";
  };

  format = "setuptools";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [ numpy pyzmq ];

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  meta = with lib; {
    description = "Python Mode-S and ADS-B Decoder";
    homepage = "https://github.com/junzis/pyModeS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ snicket2100 ];
  };
}
