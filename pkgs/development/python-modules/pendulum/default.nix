{ lib, fetchPypi, buildPythonPackage, pythonOlder
, dateutil, pytzdata, typing }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "093cab342e10516660e64b935a6da1a043e0286de36cc229fb48471415981ffe";
  };

  propagatedBuildInputs = [ dateutil pytzdata ] ++ lib.optional (pythonOlder "3.5") typing;

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Python datetimes made easy";
    homepage = "https://github.com/sdispater/pendulum";
    license = licenses.mit;
  };
}
