{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  psutil,
  six,

  # tests
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylink-square";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    tag = "v${version}";
    hash = "sha256-r0LqyyYKnwyabxuV4xRlr+0ix77zw519+VAat2it1G4=";
  };

  patches = [
    # ERROR: /build/source/setup.cfg:16: unexpected value continuation
    ./fix-setup-cfg-syntax.patch
  ];

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

  meta = {
    description = "Python interface for the SEGGER J-Link";
    homepage = "https://github.com/square/pylink";
    changelog = "https://github.com/square/pylink/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dump_stack ];
  };
}
