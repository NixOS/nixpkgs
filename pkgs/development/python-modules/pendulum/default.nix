{ lib, fetchPypi, buildPythonPackage, pythonOlder
, dateutil, pytzdata, typing }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207";
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
