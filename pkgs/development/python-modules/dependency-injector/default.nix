{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, unittest2, pyyaml, flask }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.44.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "715850f6a3bdcd5c3169c556a417c074be14fbe1c8d1b7ab1e448e1d186a311c";
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
