{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-raises";
  version = "0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Lemmons";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wmtWPWwe1sFbWSYxs5ZXDUZM1qvjRGMudWdjQeskaz0=";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_raises" ];

  disabledTests = [
    # Failed: nomatch: '*::test_pytest_mark_raises_unexpected_exception FAILED*'
    # https://github.com/Lemmons/pytest-raises/issues/30
    "test_pytest_mark_raises_unexpected_exception"
    "test_pytest_mark_raises_unexpected_match"
    "test_pytest_mark_raises_parametrize"
  ];

  meta = with lib; {
    description = "An implementation of pytest.raises as a pytest.mark fixture";
    homepage = "https://github.com/Lemmons/pytest-raises";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
