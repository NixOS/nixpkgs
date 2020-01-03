{ lib, fetchPypi, buildPythonPackage, pythonOlder
, dateutil, pytzdata, typing }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3078e007315a959989c41cee5cfd63cfeeca21dd3d8295f4bc24199489e9b6c";
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
