{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "datastar-py";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "starfederation";
    repo = "datastar-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-79pdSzHwkF8JX3rF5PIEvx//rKRvX3H1B2382Wfbm9U=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "datastar_py" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tests were only added after 1.0.0
  # TODO enable after update
  doCheck = false;

  meta = {
    changelog = "https://github.com/starfederation/datastar-python/releases/tag/${finalAttrs.src.tag}";
    description = "Helper functions and classes for the Datastar library";
    homepage = "https://github.com/starfederation/datastar-python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
