{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  netifaces,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "greeclimate";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = "greeclimate";
    rev = "refs/tags/v${version}";
    hash = "sha256-SO7/uheAPVFZ1C2qrzP7jB88u6EH79f1+qMZIgHZaCE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    netifaces
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # OSError: [Errno 101] Network is unreachable
    "test_get_device_info"
    "test_device_bind"
    "test_device_late_bind"
    "test_update_properties"
    "test_set_properties"
    "test_uninitialized_properties"
    "test_update_current_temp"
    "test_send_temperature"
    "test_enable_disable_sleep_mode"
    "test_mismatch_temrec_farenheit"
    "test_device_equality"
    "test_issue_69_TemSen_40_should_not_set_firmware_v4"
    "test_issue_87_quiet_should_set_2"
  ];

  pythonImportsCheck = [
    "greeclimate"
    "greeclimate.device"
    "greeclimate.discovery"
    "greeclimate.exceptions"
    "greeclimate.network"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Discover, connect and control Gree based minisplit systems";
    homepage = "https://github.com/cmroche/greeclimate";
    changelog = "https://github.com/cmroche/greeclimate/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
