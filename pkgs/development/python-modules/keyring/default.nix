{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, entrypoints, secretstorage
, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "keyring";
  version = "13.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6364bb8c233f28538df4928576f4e051229e0451651073ab20b315488da16a58";
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
