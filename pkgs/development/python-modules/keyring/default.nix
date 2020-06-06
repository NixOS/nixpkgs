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
  version = "21.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c53e0e5ccde3ad34284a40ce7976b5b3a3d6de70344c3f8ee44364cc340976ec";
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
