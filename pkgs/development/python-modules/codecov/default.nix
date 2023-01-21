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
  version = "2.1.12";

  src = fetchFromGitHub {
    owner = "codecov";
    repo = "codecov-python";
    rev = "v${version}";
    sha256 = "0bdk1cp3hxydpx9knqfv88ywwzw7yqhywi0inxjd6x53qh75prqy";
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
