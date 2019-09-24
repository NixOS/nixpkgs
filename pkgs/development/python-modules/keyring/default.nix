{ stdenv, buildPythonPackage, fetchPypi
, dbus-python, setuptools_scm, entrypoints, secretstorage
, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "keyring";
  version = "19.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13frfmws03jdyz9wxb4ylkvk80qiyb6a3h3sn7wx3ry97bn5li3a";
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
