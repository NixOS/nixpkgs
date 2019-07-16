{ stdenv, buildPythonPackage, fetchPypi, six, pytestcov, pytest }:

buildPythonPackage rec {
  version = "0.0.14";
  pname = "dockerfile-parse";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b829a9e25ac9af17a0affa41c0fca6541a03b8edb0178f60dc036e2ce59eeb5";
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
