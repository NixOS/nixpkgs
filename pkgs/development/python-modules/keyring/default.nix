{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27, pythonOlder
, dbus-python
, entrypoints
, importlib-metadata
, pytest
, pytest-flake8
, secretstorage
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "keyring";
  version = "20.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "963bfa7f090269d30bdc5e25589e5fd9dad2cf2a7c6f176a7f2386910e5d0d8d";
  };

  nativeBuildInputs = [ setuptools_scm ];

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
