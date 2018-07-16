{ lib, fetchPypi, buildPythonPackage, pythonOlder
, dateutil, pytzdata, typing }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "544e44d8a92954e5ef4db4fa8b662d3282f2ac7b7c2cbf4227dc193ba78b9e1e";
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
