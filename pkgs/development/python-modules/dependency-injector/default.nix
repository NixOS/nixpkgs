{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, unittest2, pyyaml, flask }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "4.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d5d42a3547a8a8d3b7aa8f4325e5042231bbc86718c89e123c0c62c103cd9d5";
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
