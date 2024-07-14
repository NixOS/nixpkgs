{
  lib,
  buildPythonPackage,
  fetchPypi,
  jpype1,
}:

buildPythonPackage rec {
  pname = "jaydebeapi";
  version = "1.2.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "JayDeBeApi";
    inherit version;
    hash = "sha256-8l6TB/u1lgywNTlMJuN3MbZMxGWxl8Q0TO6F7EUKuS8=";
  };

  propagatedBuildInputs = [ jpype1 ];

  meta = with lib; {
    homepage = "https://github.com/baztian/jaydebeapi";
    license = licenses.lgpl2;
    description = "Use JDBC database drivers from Python 2/3 or Jython with a DB-API";
  };
}
