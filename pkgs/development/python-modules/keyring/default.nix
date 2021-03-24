{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27
, dbus-python
, entrypoints
, importlib-metadata
, pytest
, pytest-flake8
, secretstorage
, setuptools_scm
, toml
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
    setuptools_scm
    toml
  ];

  checkInputs = [ pytest pytest-flake8 ];

  propagatedBuildInputs = [ dbus-python entrypoints importlib-metadata ]
  ++ lib.optional stdenv.isLinux secretstorage;

  # checks try to access a darwin path on linux
  doCheck = false;

  meta = with lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://pypi.python.org/pypi/keyring";
    license     = licenses.psfl;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
