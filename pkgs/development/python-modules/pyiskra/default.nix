{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pymodbus,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyiskra";
  version = "0.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Iskramis";
    repo = "pyiskra";
    rev = "refs/tags/v${version}";
    hash = "sha256-OLNUa11UULiW6E8nVy5rUyN7iAD7KdM+R76m2zaDOgc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pymodbus
  ];

  pythonImportsCheck = [ "pyiskra" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/Iskramis/pyiskra/releases/tag/v${version}";
    description = "Python Iskra devices interface";
    homepage = "https://github.com/Iskramis/pyiskra";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
