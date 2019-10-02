{ stdenv, buildPythonPackage, fetchPypi, isPy27
, dbus-python, setuptools_scm, entrypoints, secretstorage
, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "keyring";
  version = "19.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cvlm48fggl12m19j9vcnrlplidr2sjf8h3pdyki58f9y357q0wi";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytest-flake8 ];

  propagatedBuildInputs = [ dbus-python entrypoints ] ++ stdenv.lib.optional stdenv.isLinux secretstorage;

  # checks try to access a darwin path on linux
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://pypi.python.org/pypi/keyring";
    license     = licenses.psfl;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
