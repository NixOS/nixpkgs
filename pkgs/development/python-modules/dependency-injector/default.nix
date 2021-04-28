{ lib, buildPythonPackage, fetchPypi, isPy3k, six, unittest2, pyyaml, flask }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "4.31.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6b28b9571f44d575367c6005ba8aaa9fd2b70310e1c15410925d6f1ee2769ad";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ unittest2 pyyaml flask ];

  checkPhase = ''
    unit2 discover -s tests/unit -p "${testPath}"
  '';

  meta = with lib; {
    description = "Dependency injection microframework for Python";
    homepage = "https://github.com/ets-labs/python-dependency-injector";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
