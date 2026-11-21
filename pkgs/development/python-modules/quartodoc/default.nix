{
  lib,
  black,
  buildPythonPackage,
  click,
  fetchPypi,
  griffe,
  importlib-metadata,
  importlib-resources,
  plum-dispatch,
  pydantic,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  setuptools-scm,
  sphobjinv,
  syrupy,
  tabulate,
  typing-extensions,
  watchdog,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "quartodoc";
  version = "0.11.1";
  pyproject = true;

  # On python < 3.10 upstream requires plum-dispatch < 2, which is not in nixpkgs.
  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wSFibho2OS0WhjHzPE0+f9SNGF3heIWfjq+9oU+/6S8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    black
    click
    griffe
    importlib-metadata
    importlib-resources
    plum-dispatch
    pydantic
    pyyaml
    requests
    sphobjinv
    tabulate
    typing-extensions
    watchdog
  ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "quartodoc" ];

  meta = {
    description = "Generate API documentation with Quarto";
    homepage = "https://machow.github.io/quartodoc";
    changelog = "https://github.com/machow/quartodoc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
    mainProgram = "quartodoc";
  };
})
