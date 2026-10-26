{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  versioneer,
  attrs,
  pathspec,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "scantree";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Fb1cskSDsE2yxwZTYE6Oo1IumAh9t+OKuEgvBTmEwKw=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    attrs
    pathspec
  ];

  pythonImportsCheck = [
    "scantree"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Flexible recursive directory iterator: scandir meets glob(\"**\", recursive=True)";
    homepage = "https://github.com/andhus/scantree";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wentasah ];
  };
})
