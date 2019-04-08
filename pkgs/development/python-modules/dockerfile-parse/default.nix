{ stdenv, buildPythonPackage, fetchPypi, six, pytestcov, pytest }:

buildPythonPackage rec {
  version = "0.0.13";
  pname = "dockerfile-parse";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p0x81q3m3nlj4rqal9a959xcbjhncb548wd4wr3l7dpiajqqc9c";
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
