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
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    rev = "refs/tags/v${version}";
    hash = "sha256-WMpb/b9kF1rFlegDYxNGJbZ2Nz8nuG21tyjgUFLs5mg=";
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
    changelog = "https://github.com/square/pylink/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dump_stack ];
  };
}
