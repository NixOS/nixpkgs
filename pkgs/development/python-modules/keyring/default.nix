{ stdenv, buildPythonPackage, fetchPypi
, secretstorage
, fs, gdata, python_keyczar, pyasn1, pycrypto, six, setuptools_scm
, mock, pytest_28, pytestrunner }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "keyring";
  version = "10.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09iv50c14mdmdk7sjd6bb47yg7347gymh6r8c0q4gfnzs173y6lh";
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
