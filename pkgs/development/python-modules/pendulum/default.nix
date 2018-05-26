{ stdenv, fetchPypi, buildPythonPackage, dateutil, pytzdata, tzlocal }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "601e52cb0425e94b1784b6613a9085e0066ae1fa1915d18771884b67e93cac5c";
  };

  propagatedBuildInputs = [ dateutil pytzdata tzlocal ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python datetimes made easy";
    homepage = https://github.com/sdispater/pendulum;
    license = licenses.mit;
  };
}
