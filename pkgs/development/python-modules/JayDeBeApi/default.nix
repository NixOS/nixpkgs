{ lib
, buildPythonPackage
, fetchPypi
, JPype1
}:

buildPythonPackage rec {
  pname = "JayDeBeApi";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f25e9307fbb5960cb035394c26e37731b64cc465b197c4344cee85ec450ab92f";
  };

  propagatedBuildInputs = [
    JPype1
  ];

  meta = with lib; {
    homepage = "https://github.com/baztian/jaydebeapi";
    license = licenses.lgpl2;
    description = "Use JDBC database drivers from Python 2/3 or Jython with a DB-API";
    broken = true;
  };
}
