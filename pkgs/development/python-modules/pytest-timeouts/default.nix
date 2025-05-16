{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-timeouts";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Scony";
    repo = "pytest-timeouts";
    rev = "v${version}";
    hash = "sha256-RwUInpiEAN8joAJSZQJK5t4vTaBZ5TXKSrEZUuEuUNQ=";
  };

  dependencies = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Flaky
    "test_dummy_2"
  ];

  pythonImportsCheck = [ "pytest_timeouts" ];

  meta = {
    description = "Pytest plugin to control durations of various test case execution phases";
    homepage = "https://github.com/Scony/pytest-timeouts";
    changelog = "https://github.com/Scony/pytest-timeouts/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
