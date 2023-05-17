{ lib
, buildPythonPackage
, fetchFromGitHub
, niapy
, nltk
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "niaarm";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    rev = version;
    hash = "sha256-5XOE3c7amvhw1KrX1hcmTxneYNvAuiHz+OZLb/yhB+I=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    niapy
    nltk
    pandas
  ];

  disabledTests = [
    # Test requires extra nltk data dependency
    "test_text_mining"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaarm"
  ];

  meta = with lib; {
    description = "A minimalistic framework for Numerical Association Rule Mining";
    homepage = "https://github.com/firefly-cpp/NiaARM";
    changelog = "https://github.com/firefly-cpp/NiaARM/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
