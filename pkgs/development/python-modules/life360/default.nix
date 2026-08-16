{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "life360";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pnbruckner";
    repo = "life360";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ySa84lUyx8D7Dgg/hdZ4o/+Znn3CR0O9rdeXBrj/k5U=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "life360" ];

  meta = {
    description = "Module to interact with Life360";
    homepage = "https://github.com/pnbruckner/life360";
    changelog = "https://github.com/pnbruckner/life360/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
