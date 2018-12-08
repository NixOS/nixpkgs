{ stdenv, buildPythonPackage, fetchPypi, six, unittest2 }:

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f478a26e9bf3111ce98bbfb8502af274643947f87a7e12a6481a35eaa693062b";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ unittest2 ];

  checkPhase = ''
    unit2 discover tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Dependency injection microframework for Python";
    homepage = https://github.com/ets-labs/python-dependency-injector;
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
