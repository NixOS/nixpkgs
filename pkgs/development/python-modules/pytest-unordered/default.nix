{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-unordered";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utapyngo";
    repo = "pytest-unordered";
    tag = "v${version}";
    hash = "sha256-JmP2zStxIt+u7sgfRKlnBwM5q5R0GfXtiE7ZgHKtg94=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_unordered" ];

  meta = with lib; {
    changelog = "https://github.com/utapyngo/pytest-unordered/blob/v${version}/CHANGELOG.md";
    description = "Test equality of unordered collections in pytest";
    homepage = "https://github.com/utapyngo/pytest-unordered";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
