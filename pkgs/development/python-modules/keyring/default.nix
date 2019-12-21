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
  version = "20.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc9cadedae35b77141f670f84c10a657147d2e526348698c93dd77f039979729";
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
