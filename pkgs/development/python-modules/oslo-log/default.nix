{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, eventlet
, oslo-config
, oslo-context
, oslo-serialization
, oslo-utils
, oslotest
, pbr
, pyinotify
, python-dateutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "oslo-log";
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "oslo.log";
    inherit version;
    hash = "sha256-+2Xy+dJEI/pt1urY7NIfZlxi4P2fkL8xHkwVO1+Kt+o=";
  };

  propagatedBuildInputs = [
    oslo-config
    oslo-context
    oslo-serialization
    oslo-utils
    pbr
    python-dateutil
  ] ++ lib.optionals stdenv.isLinux [
    pyinotify
  ];

  checkInputs = [
    eventlet
    oslotest
    pytestCheckHook
  ];

  disabledTests = [
    # not compatible with sandbox
    "test_logging_handle_error"
  ];

  pythonImportsCheck = [
    "oslo_log"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "oslo.log library";
    homepage = "https://github.com/openstack/oslo.log";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
