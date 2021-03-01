{ lib, buildPythonPackage, fetchPypi, isPy3k, six, unittest2, pyyaml, flask }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "4.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93db83fac85bcb861469c0db1af11f4bc874aa2f9380151189a05d38c21afd60";
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
