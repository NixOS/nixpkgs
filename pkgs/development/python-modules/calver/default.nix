{ lib
, buildPythonPackage
, fetchPypi
}:
let
  pname = "calver";
  version = "2022.6.26";

in
buildPythonPackage {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4FSTo7F1F+8XSPvmENoR8QSF+qfEFrnTP9SlLXSJT4s=";
  };

  meta = {
    description = "Setuptools extension for CalVer package versions";
    homepage = "https://github.com/di/calver";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
