{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, unittest2 }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.14.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e0c73fbec99d2782479f6d8c292be87ed8672eb42b451e7f7a5d52a3458c4e5";
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
