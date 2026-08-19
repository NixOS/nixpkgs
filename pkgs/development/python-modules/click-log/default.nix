{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-log";
  version = "0.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "click-log";
    inherit (finalAttrs) version;
    hash = "sha256-OXD4VwrFRJEje82z2KtePu9sBX3yn4w9EVGlGpwjuXU=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  pythonImportsCheck = [ "click_log" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/click-contrib/click-log/";
    description = "Logging integration for Click";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
