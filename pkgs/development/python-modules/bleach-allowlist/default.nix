{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bleach,
}:

buildPythonPackage (finalAttrs: {
  pname = "bleach-allowlist";
  version = "1.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VuIghgeaDmoxAK6Z5NuvIOslhUhlmOsOmUAIoRQo2ps=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleach ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "bleach_allowlist" ];

  meta = {
    description = "Curated lists of tags and attributes for sanitizing html";
    homepage = "https://github.com/yourcelf/bleach-allowlist";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
