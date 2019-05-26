{ lib, fetchPypi, buildPythonPackage, pythonOlder
, dateutil, pytzdata, typing }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf535d36c063575d4752af36df928882b2e0e31541b4482c97d63752785f9fcb";
  };

  propagatedBuildInputs = [ dateutil pytzdata ] ++ lib.optional (pythonOlder "3.5") typing;

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Python datetimes made easy";
    homepage = https://github.com/sdispater/pendulum;
    license = licenses.mit;
  };
}
