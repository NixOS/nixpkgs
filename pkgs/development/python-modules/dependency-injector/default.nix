{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, unittest2 }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.14.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0b593d30a9dcafd71459075fac14ccf52fcefa2094d5062dfc2e174c469dc03";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ unittest2 ];

  checkPhase = ''
    unit2 discover -s tests/unit -p "${testPath}"
  '';

  meta = with stdenv.lib; {
    description = "Dependency injection microframework for Python";
    homepage = https://github.com/ets-labs/python-dependency-injector;
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
