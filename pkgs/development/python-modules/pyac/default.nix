{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyac";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+TaBzbvuJaYAZKDidE5irDcRa0ZXtnUdlIRWvCf4mjs=";
  };

  pythonImportsCheck = [ "pyac" ];

  meta = with lib; {
    description = "Library for activeCollab 3.x/4.x";
    homepage = "https://github.com/kostajh/pyac";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
