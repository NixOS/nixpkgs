{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytest,
  pytestCheckHook,
  pytest-describe,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-spec";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pchomik";
    repo = "pytest-spec";
    tag = finalAttrs.version;
    hash = "sha256-2DXC02FSiGzsavdkoDFlxKdYaYpPAy3VbEG4YZSO5c8=";
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
    changelog = "https://github.com/pchomik/pytest-spec/blob/${finalAttrs.src.rev}/CHANGES.txt";
    description = "Pytest plugin to display test execution output like a SPECIFICATION";
    homepage = "https://github.com/pchomik/pytest-spec";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
