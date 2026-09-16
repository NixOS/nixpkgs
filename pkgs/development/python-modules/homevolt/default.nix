{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "homevolt";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyHomevolt";
    tag = finalAttrs.version;
    hash = "sha256-70as5Hi5/AR5o43/oRVIlW1f8P2pW6KpMSOlfGdWpfw=";
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
