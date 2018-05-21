{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, entrypoints, secretstorage
, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "keyring";
  version = "12.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "445d9521b4fcf900e51c075112e25ddcf8af1db7d1d717380b64eda2cda84abc";
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
