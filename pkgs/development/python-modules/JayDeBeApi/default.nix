{ lib
, buildPythonPackage
, fetchPypi
, JPype1
}:

buildPythonPackage rec {
  pname = "JayDeBeApi";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9847e437ad293ee3cc47767b74c387068cd21607842de8470d5d3f13d613083";
  };

  propagatedBuildInputs = [
    JPype1
  ];

  meta = with lib; {
    homepage = "https://github.com/baztian/jaydebeapi";
    license = licenses.lgpl2;
    description = "Use JDBC database drivers from Python 2/3 or Jython with a DB-API";
  };
}
