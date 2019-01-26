{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, unittest2 }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.14.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07366palyav9bawyq2b1gi76iamjkq6r5akzzbqv8s930sxq6yim";
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
