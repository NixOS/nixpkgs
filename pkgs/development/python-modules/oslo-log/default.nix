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
<<<<<<< HEAD
  version = "5.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "5.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "oslo.log";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-zJSqvbUOHiVxxsvEs5lpSgVBV2c1kIqYSgIjqeH72z4=";
=======
    hash = "sha256-YiYzbVtu4YhfBXtl2+3oTEqcXk5K51oOjn84PBY+xIA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = [
    eventlet
    oslotest
    pytestCheckHook
  ];

  disabledTests = [
    # not compatible with sandbox
    "test_logging_handle_error"
<<<<<<< HEAD
    # File which is used doesn't seem not to be present
    "test_log_config_append_invalid"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "oslo_log"
  ];

  meta = with lib; {
<<<<<<< HEAD
=======
    broken = stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "oslo.log library";
    homepage = "https://github.com/openstack/oslo.log";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
<<<<<<< HEAD
    broken = stdenv.isDarwin;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
