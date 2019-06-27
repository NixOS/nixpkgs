{ lib, buildPythonPackage, fetchFromGitHub
, future, python-language-server, mypy, configparser
, pytest, mock, isPy3k, pytestcov, coverage
}:

buildPythonPackage rec {
  pname = "pyls-mypy";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "tomv564";
    repo = "pyls-mypy";
    rev = version;
    sha256 = "0c1111m9h6f05frkyj6i757q9y2lijpbv8nxmwgp3nqbpkvfnmrk";
  };

  disabled = !isPy3k;

  checkPhase = ''
    HOME=$TEMPDIR pytest
  '';

  checkInputs = [ pytest mock pytestcov coverage ];

  propagatedBuildInputs = [
    mypy python-language-server future configparser
  ];

  meta = with lib; {
    homepage = https://github.com/tomv564/pyls-mypy;
    description = "Mypy plugin for the Python Language Server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
