{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "airthings-cloud";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyAirthings";
    tag = finalAttrs.version;
    hash = "sha256-8fB8bQ7GHPnNk4lVtP5yZ6ys3J2R+olqSPCPpGquWRk=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "airthings" ];

  meta = {
    description = "Python module for Airthings";
    homepage = "https://github.com/Danielhiversen/pyAirthings";
    changelog = "https://github.com/Danielhiversen/pyAirthings/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
