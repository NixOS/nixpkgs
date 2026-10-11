{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytest,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-skip-slow";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okken";
    repo = "pytest-skip-slow";
    tag = finalAttrs.version;
    hash = "sha256-6S41EjP8o9MRl7XMDF/P4MrTh6AMaQ9HsPDTm345NbA=";
  };

  build-system = [ flit-core ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_skip_slow" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pytest plugin to skip `@pytest.mark.slow` tests by default";
    homepage = "https://github.com/okken/pytest-skip-slow";
    changelog = "https://github.com/okken/pytest-skip-slow/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
