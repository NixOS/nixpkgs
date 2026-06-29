{
  lib,
  basedpyright,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hatchling,
  mypy,
  pyrefly,
  pyright,
  pytest,
  pytestCheckHook,
  schema,
  ty,
  typeguard,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-revealtype-injector";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abelcheung";
    repo = "pytest-revealtype-injector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HXYH2CE6AQVBTm/Lse3qGMeNeuHVg5rqztVhSZKrry4=";
  };

  build-system = [ hatchling ];

  patches = [
    # Support mypy 1.20 additional schema fields
    # https://github.com/abelcheung/pytest-revealtype-injector/pull/33
    (fetchpatch {
      url = "https://github.com/attilaolah/pytest-revealtype-injector/commit/f063c687a24b34daa0dd94f5fc2cf3a835211d0e.patch";
      hash = "sha256-3HTDMqxAbKjuC9ulC/rXQgLnQEaBduqO6n2jQPU9r9E=";
    })
  ];

  buildInputs = [ pytest ];

  dependencies = [
    schema
    typeguard
    typing-extensions
  ];

  nativeCheckInputs = [
    basedpyright
    mypy
    pyrefly
    pyright
    pytestCheckHook
    ty
  ];

  # Upstream's pytester tests load the plugin explicitly in nested pytest runs.
  preCheck = ''
    export PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
  '';

  pytestFlags = [ "--runpytest=subprocess" ];

  disabledTests = [
    # pyrefly does not infer reveal_type results for these AST transformations.
    "test_nested_call"
    "test_return_result"
    # ty reports invalid-assignment before the runtime import tests execute.
    "test_basic"
    "test_import_as"
    "test_import_module_as"
  ];

  pythonImportsCheck = [ "pytest_revealtype_injector" ];

  meta = {
    description = "Pytest plugin for replacing reveal_type calls with static and runtime checks";
    homepage = "https://github.com/abelcheung/pytest-revealtype-injector";
    changelog = "https://github.com/abelcheung/pytest-revealtype-injector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
  };
})
