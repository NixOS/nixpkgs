{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, importlib-metadata
, dbus-python
<<<<<<< HEAD
, jaraco-classes
=======
, jaraco_classes
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, jeepney
, secretstorage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "keyring";
<<<<<<< HEAD
  version = "24.2.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ygdGoZ7EISGfTXE/hI+il6ZhqKjBUEhn5Vv7XgkJFQk=";
=======
  version = "23.13.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ui4VqbNeIZCNCq9OCkesxS1q4zRE3w2itJ1BpG721ng=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    jaraco-classes
=======
    jaraco_classes
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  ]
  # These tests fail when sandboxing is enabled because they are unable to get a password from keychain.
  ++ lib.optional stdenv.isDarwin "tests/test_multiprocess.py";
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://github.com/jaraco/keyring";
<<<<<<< HEAD
    changelog   = "https://github.com/jaraco/keyring/blob/v${version}/NEWS.rst";
=======
    changelog   = "https://github.com/jaraco/keyring/blob/v${version}/CHANGES.rst";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 dotlambda ];
    platforms   = platforms.unix;
  };
}
