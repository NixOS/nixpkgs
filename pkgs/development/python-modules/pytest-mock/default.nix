{ lib
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40217a058c52a63f1042f0784f62009e976ba824c418cced42e88d5f40ab0e62";
  };

  nativeBuildInputs = [ setuptools-scm ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # output of pytest has changed
    "test_used_with_"
    "test_plain_stopall"
  ];

  pythonImportsCheck = [ "pytest_mock" ];

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with pytest";
    homepage = "https://github.com/pytest-dev/pytest-mock";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
