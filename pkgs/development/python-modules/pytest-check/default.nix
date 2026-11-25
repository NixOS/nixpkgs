{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-check";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okken";
    repo = "pytest-check";
    tag = finalAttrs.version;
    hash = "sha256-jrI9F9K/51Jl8unp53TB+CrYahhQz5zZH7ulBaISNSU=";
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert '99' not in '===========...============'
    "test_long_locals_follow_verbosity"
  ];

  pythonImportsCheck = [ "pytest_check" ];

  meta = {
    description = "Pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    changelog = "https://github.com/okken/pytest-check/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      flokli
      sarahec
    ];
  };
})
