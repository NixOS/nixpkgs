{ lib
, stdenv
, buildPythonPackage
, fetchPypi
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
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "oslo.log";
    inherit version;
    hash = "sha256-c6tyNKii1QvfUmyHTfocsrEIO6+a2VvC64r1YkidTQE=";
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
