{
  aiohttp,
  buildPythonPackage,
  dacite,
  fetchFromGitHub,
  hatchling,
  lib,
  pyjwt,
}:

buildPythonPackage rec {
  pname = "igloohome-api";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keithle888";
    repo = "igloohome-api";
    tag = "v${version}";
    hash = "sha256-CFxVZiga6008oNbacK12t7U8mOvL8YgEgQ82MsvZ46w=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    dacite
    pyjwt
  ];

  pythonImportsCheck = [ "igloohome_api" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/keithle888/igloohome-api/releases/tag/${src.tag}";
    description = "Python package for using igloohome's API";
    homepage = "https://github.com/keithle888/igloohome-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
