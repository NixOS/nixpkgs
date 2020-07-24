{ stdenv, buildPythonPackage, fetchPypi
, dbus-python, setuptools_scm, entrypoints, secretstorage
, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "keyring";
  version = "18.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f58jq58jhfzlhix7x2zz7c4ycdvcs1z3sgs4lkr4xxx680wrmk7";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytest-flake8 ];

  propagatedBuildInputs = [ dbus-python entrypoints ] ++ stdenv.lib.optional stdenv.isLinux secretstorage;

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://pypi.python.org/pypi/keyring";
    license     = licenses.psfl;
    maintainers = with maintainers; [ lovek323 orivej ];
    platforms   = platforms.unix;
  };
}
