{ stdenv, buildPythonPackage, fetchPypi, six, unittest2 }:

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14b2e48c272b546c1a2e76943df0e8e28b5a791cdec5388bc526132b10b09d42";
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
