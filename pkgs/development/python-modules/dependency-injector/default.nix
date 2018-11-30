{ stdenv, buildPythonPackage, fetchPypi, six, unittest2 }:

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kgb40qspibr1x8ksv0whrr7v0jy20dnqzmc591hm2y4kwzl5hdw";
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
