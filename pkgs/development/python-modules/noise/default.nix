{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "noise";
  version = "1.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V6J5dDZXQ5H/Y6ER6FLlOkFk7Nga0jY5ZBdDzRogm2U=";
  };

  build-system = [ setuptools ];

  # PyPI release don't contain tests
  doCheck = false;

  pythonImportsCheck = [ "noise" ];

  meta = {
    description = "Native-code and shader implementations of Perlin noise";
    homepage = "https://github.com/caseman/noise";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
