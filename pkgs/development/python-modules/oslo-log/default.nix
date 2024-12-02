{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  eventlet,
  oslo-config,
  oslo-context,
  oslo-serialization,
  oslo-utils,
  oslotest,
  pbr,
  pyinotify,
  python-dateutil,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oslo-log";
  version = "6.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "oslo.log";
    inherit version;
    hash = "sha256-92gEffnXBsSE3WZl3LvqKJAh1Iy3zlq/eh9poJSR9f4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    oslo-config
    oslo-context
    oslo-serialization
    oslo-utils
    pbr
    python-dateutil
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ pyinotify ];

  nativeCheckInputs = [
    eventlet
    oslotest
    pytestCheckHook
  ];

  disabledTests = [
    # not compatible with sandbox
    "test_logging_handle_error"
    # File which is used doesn't seem not to be present
    "test_log_config_append_invalid"
  ];

  pythonImportsCheck = [ "oslo_log" ];

  meta = with lib; {
    description = "oslo.log library";
    mainProgram = "convert-json";
    homepage = "https://github.com/openstack/oslo.log";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
