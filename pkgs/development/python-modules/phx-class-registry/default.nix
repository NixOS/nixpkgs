{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  hatchling,
}:
buildPythonPackage (finalAttrs: {
  pname = "phx-class-registry";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "todofixthis";
    repo = "class-registry";
    tag = finalAttrs.version;
    hash = "sha256-F6AR1D65HXp1VJCHiEj4OMe2eASitN5+Mulk1m8nBCQ=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "class_registry" ];

  meta = {
    description = "Factory and registry pattern for Python classes";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
})
