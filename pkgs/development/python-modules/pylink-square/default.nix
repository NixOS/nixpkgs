{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, mock
, psutil
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "pylink-square";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    rev = "refs/tags/v${version}";
    hash = "sha256-rcM7gvUUfXN5pL9uIihzmOCXA7NKjiMt2GaQaGJxD9M=";
  };

  propagatedBuildInputs = [
    psutil
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylink"
  ];

  disabledTests = [
    # AttributeError: 'called_once_with' is not a valid assertion
    "test_cp15_register_write_success"
    "test_jlink_restarted"
    "test_set_log_file_success"
  ];

  meta = with lib; {
    description = "Python interface for the SEGGER J-Link";
    homepage = "https://github.com/square/pylink";
    changelog = "https://github.com/square/pylink/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dump_stack ];
  };
}
