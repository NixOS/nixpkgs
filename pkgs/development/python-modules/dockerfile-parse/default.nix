{ stdenv, buildPythonPackage, fetchPypi, six, pytestcov, pytest }:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "dockerfile-parse";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ed92ede29a646094b52b8b302e477f08e63465b6ee524f5750810280143712e";
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
