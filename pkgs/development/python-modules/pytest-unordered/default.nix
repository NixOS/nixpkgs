{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-unordered";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utapyngo";
    repo = "pytest-unordered";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Zh58qWKJIUL/7ELiZmyFNVKUyiJeckpYTQBnqKROo4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_unordered" ];

  meta = {
    changelog = "https://github.com/utapyngo/pytest-unordered/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Test equality of unordered collections in pytest";
    homepage = "https://github.com/utapyngo/pytest-unordered";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
