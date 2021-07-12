{ lib, buildPythonPackage, fetchPypi, six, pytestcov, pytest }:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "dockerfile-parse";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07e65eec313978e877da819855870b3ae47f3fac94a40a965b9ede10484dacc5";
  };

  postPatch = ''
    echo " " > tests/requirements.txt \
  '';

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestcov pytest ];

  meta = with lib; {
    description = "Python library for parsing Dockerfile files";
    homepage = "https://github.com/DBuildService/dockerfile-parse";
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
