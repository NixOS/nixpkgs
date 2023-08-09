{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, importlib-metadata
, dbus-python
, jaraco-classes
, jeepney
, secretstorage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "keyring";
  version = "24.2.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ygdGoZ7EISGfTXE/hI+il6ZhqKjBUEhn5Vv7XgkJFQk=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jaraco-classes
  ] ++ lib.optionals stdenv.isLinux [
    jeepney
    secretstorage
  ] ++ lib.optionals (pythonOlder "3.12") [
    importlib-metadata
  ];

  pythonImportsCheck = [
    "keyring"
    "keyring.backend"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/backends/test_macOS.py"
  ]
  # These tests fail when sandboxing is enabled because they are unable to get a password from keychain.
  ++ lib.optional stdenv.isDarwin "tests/test_multiprocess.py";

  meta = with lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://github.com/jaraco/keyring";
    changelog   = "https://github.com/jaraco/keyring/blob/v${version}/NEWS.rst";
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 dotlambda ];
    platforms   = platforms.unix;
  };
}
