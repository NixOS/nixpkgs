{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  psutil,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "pylink-square";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    tag = "v${version}";
    hash = "sha256-Fjulh2wmcVO+/608uTO10orRz8Pq0I+ZhJ8zMa3YFC0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    psutil
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylink" ];

  disabledTests = [
    # AttributeError: 'called_once_with' is not a valid assertion
    "test_cp15_register_write_success"
    "test_jlink_restarted"
    "test_set_log_file_success"
  ];

  meta = with lib; {
    description = "Python interface for the SEGGER J-Link";
    homepage = "https://github.com/square/pylink";
    changelog = "https://github.com/square/pylink/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dump_stack ];
  };
}
