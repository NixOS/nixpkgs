{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27, pythonOlder
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
  version = "21.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "22df6abfed49912fc560806030051067fba9f0069cffa79da72899aeea4ccbd5";
  };

  nativeBuildInputs = [
    setuptools_scm
    toml
  ];

  checkInputs = [ pytest pytest-flake8 ];

  propagatedBuildInputs = [ dbus-python entrypoints ]
  ++ lib.optional stdenv.isLinux secretstorage
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

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
