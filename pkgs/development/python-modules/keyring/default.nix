{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, entrypoints, secretstorage
, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "keyring";
  version = "16.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95e4f1d0342d0bf5d137d1d2352d59f7abbebb1507bec1ac26831c411ac23150";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytest-flake8 ];

  propagatedBuildInputs = [ entrypoints ] ++ stdenv.lib.optional stdenv.isLinux secretstorage;

  doCheck = !stdenv.isDarwin;

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
