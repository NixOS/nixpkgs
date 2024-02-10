{ lib
, buildPythonPackage
, coverage
, ddt
, fetchFromGitHub
, mock
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.1.13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "codecov";
    repo = "codecov-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-cZEpAw8uv/XGiGzdBZ9MnabNaTP0did2GT+BkKMJM/E=";
  };

  propagatedBuildInputs = [
    requests
    coverage
  ];

  nativeCheckInputs = [
    ddt
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/test.py" ];

  disabledTests = [
    # No git repo available and network
    "test_bowerrc_none"
    "test_prefix"
    "test_send"
  ];

  pythonImportsCheck = [ "codecov" ];

  meta = with lib; {
    description = "Python report uploader for Codecov";
    homepage = "https://codecov.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
