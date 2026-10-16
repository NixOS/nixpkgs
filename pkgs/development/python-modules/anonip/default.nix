{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "anonip";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DigitaleGesellschaft";
    repo = "Anonip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DJO0fK+S1fQvHAjCiOzE8HJ5ng17hw9Z/LKpFjNrWjM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "anonip" ];

  meta = {
    description = "Tool to anonymize IP addresses in log files";
    mainProgram = "anonip";
    homepage = "https://github.com/DigitaleGesellschaft/Anonip";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mmahut ];
  };
})
