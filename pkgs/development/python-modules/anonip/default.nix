{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "anonip";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DigitaleGesellschaft";
    repo = "Anonip";
    rev = "v${version}";
    sha256 = "0cssdcridadjzichz1vv1ng7jwphqkn8ihh83hpz9mcjmxyb94qc";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "anonip" ];

  meta = with lib; {
    description = "Tool to anonymize IP addresses in log files";
    mainProgram = "anonip";
    homepage = "https://github.com/DigitaleGesellschaft/Anonip";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
  };
}
