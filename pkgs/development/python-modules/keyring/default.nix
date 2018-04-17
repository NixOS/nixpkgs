{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, entrypoints, secretstorage
, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "keyring";
  version = "12.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "846c9c709ee1203bac5444abec19b5228f4601377686f33cba672aa0ba313abd";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytest-flake8 ];

  propagatedBuildInputs = [ entrypoints ] ++ stdenv.lib.optional stdenv.isLinux secretstorage;

  # all tests with flake8 are broken right now
  # https://github.com/tholo/pytest-flake8/issues/45
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://pypi.python.org/pypi/keyring";
    license     = licenses.psfl;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
