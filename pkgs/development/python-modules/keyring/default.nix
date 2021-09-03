{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, importlib-metadata
, dbus-python
, jeepney
, secretstorage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "keyring";
  version = "23.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "045703609dd3fccfcdb27da201684278823b72af515aedec1a8515719a038cb8";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    # this should be optional, however, it has a different API
    importlib-metadata # see https://github.com/jaraco/keyring/issues/503#issuecomment-798973205

    dbus-python
    jeepney
    secretstorage
  ];

  pythonImportsCheck = [
    "keyring"
    "keyring.backend"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Keychain communications isn't possible in our build environment
  # keyring.errors.KeyringError: Can't get password from keychain: (-25307, 'Unknown Error')
  disabledTests = lib.optionals (stdenv.isDarwin) [
    "test_multiprocess_get"
    "test_multiprocess_get_after_native_get"
  ];

  disabledTestPaths = [
    "tests/backends/test_macOS.py"
  ];

  meta = with lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://github.com/jaraco/keyring";
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 dotlambda ];
    platforms   = platforms.unix;
  };
}
