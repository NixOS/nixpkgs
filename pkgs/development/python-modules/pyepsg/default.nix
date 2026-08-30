{
  buildPythonPackage,
  lib,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pyepsg";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LQj60eeotHqQpOQ9pIW6lXBZI0Ja78Tio++lQNvUcNc=";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = {
    description = "Simple Python interface to epsg.io";
    license = lib.licenses.lgpl3;
    homepage = "https://pyepsg.readthedocs.io/en/latest/";
    maintainers = [ ];
  };
}
