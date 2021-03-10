{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27, pythonOlder
, setuptools-scm
, toml
, importlib-metadata
, dbus-python
, jeepney
, secretstorage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "keyring";
  version = "23.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "237ff44888ba9b3918a7dcb55c8f1db909c95b6f071bfb46c6918f33f453a68a";
  };

  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    importlib-metadata
  ] ++ lib.optionals stdenv.isLinux [
    dbus-python
    jeepney
    secretstorage
  ];

  pythonImportsCheck = [ "keyring" ];

  meta = with lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://github.com/jaraco/keyring";
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 dotlambda ];
    platforms   = platforms.unix;
  };
}
