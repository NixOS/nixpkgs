{ stdenv, buildPythonPackage, fetchPypi
, secretstorage
, fs, gdata, python_keyczar, pyasn1, pycrypto, six, setuptools_scm
, mock, pytest_28, pytestrunner }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "keyring";
  version = "10.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f10674bb6ecbf82e2b713627c48ad0e84178e1c9d3dc1f0373261a0765402fb2";
  };

  buildInputs = [
    fs gdata python_keyczar pyasn1 pycrypto six setuptools_scm
  ];

  checkInputs = [ mock pytest_28 pytestrunner ];

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
