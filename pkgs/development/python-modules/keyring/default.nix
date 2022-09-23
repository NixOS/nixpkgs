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
  version = "23.7.0";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eC4c0RMukb9Fn80kO88lsyYBXBrAsZjkQI+R+meRBis=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ] ++ lib.optionals stdenv.isLinux [
    jeepney
    secretstorage
    dbus-python
  ];

  pythonImportsCheck = [
    "keyring"
    "keyring.backend"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
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
