{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, unittest2 }:

let
  testPath =
    if isPy3k
    then "test_*_py3.py"
    else "test_*_py2_py3.py";
in

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.14.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c475axh40f8s4n5dqm52qczx9g2g8b8wsy0qvghirk84ikpca5y";
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
