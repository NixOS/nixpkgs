{ lib, buildPythonPackage, fetchFromGitHub
, future, python-language-server, mypy, configparser
, pytest, mock, isPy3k, pytestcov, coverage
}:

buildPythonPackage rec {
  pname = "pyls-mypy";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "tomv564";
    repo = "pyls-mypy";
    rev = version;
    sha256 = "0v7ghcd1715lxlfq304b7xhchp31ahdd89lf6za4n0l59dz74swh";
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
