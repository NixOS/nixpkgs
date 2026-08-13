{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "homevolt";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyHomevolt";
    tag = finalAttrs.version;
    hash = "sha256-Z+3JwACbdFVivWbhlxO73m1rjyGS+Vc/Y3QICqEY9O0=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "homevolt" ];

  meta = {
    description = "Python library for Homevolt EMS devices";
    homepage = "https://github.com/Danielhiversen/pyHomevolt";
    changelog = "https://github.com/Danielhiversen/pyHomevolt/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
