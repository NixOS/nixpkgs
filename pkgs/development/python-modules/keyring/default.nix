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
  version = "23.2.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6334aee6073db2fb1f30892697b1730105b5e9a77ce7e61fca6b435225493efe";
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
  ] ++ [
    # E       ValueError: too many values to unpack (expected 1)
    "test_entry_point"
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
