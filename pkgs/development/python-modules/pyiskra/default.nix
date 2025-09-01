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
  version = "0.1.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Iskramis";
    repo = "pyiskra";
    tag = "v${version}";
    hash = "sha256-feD4oqH7W0gJwPqdgAJEzmnadgXHkzFDc/NXY54aMXI=";
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
    changelog = "https://github.com/Iskramis/pyiskra/releases/tag/${src.tag}";
    description = "Python Iskra devices interface";
    homepage = "https://github.com/Iskramis/pyiskra";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
