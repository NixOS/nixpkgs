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
    sha256 = "0cssdcridadjzichz1vv1ng7jwphqkn8ihh83hpz9mcjmxyb94qc";
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
