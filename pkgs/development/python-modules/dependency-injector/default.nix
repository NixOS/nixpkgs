{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, unittest2, pyyaml, flask }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "4.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "345bfa4185802a712e27903b5612d4748a1e2483c3d5da8d840d8a401aeb75ea";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ unittest2 pyyaml flask ];

  checkPhase = ''
    unit2 discover -s tests/unit -p "${testPath}"
  '';

  meta = with stdenv.lib; {
    description = "Dependency injection microframework for Python";
    homepage = "https://github.com/ets-labs/python-dependency-injector";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
