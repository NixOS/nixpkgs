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
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pchomik";
    repo = "pytest-spec";
    tag = version;
    hash = "sha256-uzl7T2h7s2YjC0nd1FbubRca8oTU4kEe4cEpIGPLaHA=";
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
    changelog = "https://github.com/pchomik/pytest-spec/blob/${src.tag}/CHANGES.txt";
    description = "Pytest plugin to display test execution output like a SPECIFICATION";
    homepage = "https://github.com/pchomik/pytest-spec";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
