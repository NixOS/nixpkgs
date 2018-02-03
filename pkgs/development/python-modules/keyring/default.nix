{ stdenv, buildPythonPackage, fetchPypi
, secretstorage
, fs, gdata, python_keyczar, pyasn1, pycrypto, six, setuptools_scm
, mock, pytest, pytestrunner }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "keyring";
  version = "10.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69c2b69d66a0db1165c6875c1833c52f4dc62179959692b30c8c4a4b8390d895";
  };

  buildInputs = [
    fs gdata python_keyczar pyasn1 pycrypto six setuptools_scm
  ];

  checkInputs = [ mock pytest pytestrunner ];

  propagatedBuildInputs = [ secretstorage ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    py.test $out
  '';

  meta = with stdenv.lib; {
    description = "Store and access your passwords safely";
    homepage    = "https://pypi.python.org/pypi/keyring";
    license     = licenses.psfl;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
