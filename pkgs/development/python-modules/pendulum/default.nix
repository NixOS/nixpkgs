{ stdenv, fetchPypi, buildPythonPackage, dateutil, pytzdata, tzlocal }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e996c34fb101c9c6d88a839c19af74d7c067b92ed3371274efcf4d4b6dc160a6";
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
