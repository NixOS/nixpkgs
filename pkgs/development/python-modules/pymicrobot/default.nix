{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymicrobot";
  version = "0.0.23";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fRCXCT3DR42HhYom23hVcWBXFngLPn7UZmyKrjb+MNY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "microbot" ];

  meta = {
    description = "Library to communicate with MicroBot";
    homepage = "https://github.com/spycle/pyMicroBot/";
    changelog = "https://github.com/spycle/pyMicroBot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
