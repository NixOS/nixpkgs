{ stdenv, buildPythonPackage, fetchPypi, six, pytestcov, pytest }:

buildPythonPackage rec {
  version = "0.0.15";
  pname = "dockerfile-parse";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s05s1hc834yk6qxj2yv3fh7grj3q52d6jjy0sv1p05938baprfm";
  };

  postPatch = ''
    echo " " > tests/requirements.txt \
  '';

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestcov pytest ];

  meta = with stdenv.lib; {
    description = "Python library for parsing Dockerfile files";
    homepage = https://github.com/DBuildService/dockerfile-parse;
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
