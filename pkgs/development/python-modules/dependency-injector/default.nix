{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, unittest2 }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.30.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "717388a9346883eb5def3e96def7275763f2a607cac48c272f352e3834e0bd0d";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ unittest2 ];

  checkPhase = ''
    unit2 discover -s tests/unit -p "${testPath}"
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Dependency injection microframework for Python";
    homepage = "https://github.com/ets-labs/python-dependency-injector";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
