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
}:

buildPythonPackage rec {
  pname = "oslo-log";
  version = "6.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "oslo.log";
    inherit version;
    hash = "sha256-ifDW+iy6goH4m1CKf+Sb+5far1XFJ4GH1FowaZceaH8=";
  };

  propagatedBuildInputs = [
    oslo-config
    oslo-context
    oslo-serialization
    oslo-utils
    pbr
    python-dateutil
  ] ++ lib.optionals stdenv.isLinux [ pyinotify ];

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
    broken = stdenv.isDarwin;
  };
}
