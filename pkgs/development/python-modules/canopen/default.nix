{
  lib,
  buildPythonPackage,
  canmatrix,
  fetchPypi,
  pytestCheckHook,
  python-can,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "canopen";
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IKhLxJizTa3XnOzkZ9O74ZWRwcAqjzkzG8xgZcTYsus=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools-scm ];

  dependencies = [ python-can ];

  optional-dependencies = {
    db_export = [ canmatrix ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Timing-sensitive: 10-50 ms threading.Timer or SDO response timeouts
    # race against short waits and fail at random on loaded builders
    "test_emcy_consumer_wait"
    "test_nmt_master_on_heartbeat"
    "test_nmt_master_on_heartbeat_initialising"
    "test_nmt_master_on_heartbeat_unknown_state"
    "test_nmt_master_wait_for_bootup"
    "test_sdo_block_upload_retransmit"
  ];

  pythonImportsCheck = [ "canopen" ];

  meta = {
    description = "CANopen stack implementation";
    homepage = "https://github.com/christiansandberg/canopen/";
    changelog = "https://github.com/christiansandberg/canopen/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sorki ];
  };
}
