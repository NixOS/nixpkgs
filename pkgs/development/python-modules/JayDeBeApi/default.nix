{ lib
, buildPythonPackage
, fetchPypi
, JPype1
}:

buildPythonPackage rec {
  pname = "JayDeBeApi";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a189xs9zw81jvwwglvf2qyqnk6ra0biljssx9n4ffayqn9glbds";
  };

  propagatedBuildInputs = [
    JPype1
  ];

  meta = with lib; {
    homepage = https://github.com/baztian/jaydebeapi;
    license = licenses.lgpl2;
    description = "Use JDBC database drivers from Python 2/3 or Jython with a DB-API";
  };
}
