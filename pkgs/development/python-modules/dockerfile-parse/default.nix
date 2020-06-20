{ stdenv, buildPythonPackage, fetchPypi, six, pytestcov, pytest }:

buildPythonPackage rec {
  version = "0.0.18";
  pname = "dockerfile-parse";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a09eae6871b7b314f8a8bddb67b6c5002708b22247511906cf2a9a45564b83db";
  };

  postPatch = ''
    echo " " > tests/requirements.txt \
  '';

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestcov pytest ];

  meta = with stdenv.lib; {
    description = "Python library for parsing Dockerfile files";
    homepage = "https://github.com/DBuildService/dockerfile-parse";
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
