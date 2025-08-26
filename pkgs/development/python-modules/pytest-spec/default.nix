{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytest,
  pytestCheckHook,
  pytest-describe,
}:

buildPythonPackage rec {
  pname = "pytest-spec";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pchomik";
    repo = "pytest-spec";
    tag = version;
    hash = "sha256-EWhKqGOLBa+Eb4fJtkamP8it+hWeK3rGWKgY8mJI53U=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-describe
  ];

  pythonImportsCheck = [ "pytest_spec" ];

  meta = {
    changelog = "https://github.com/pchomik/pytest-spec/blob/${src.rev}/CHANGES.txt";
    description = "Pytest plugin to display test execution output like a SPECIFICATION";
    homepage = "https://github.com/pchomik/pytest-spec";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
