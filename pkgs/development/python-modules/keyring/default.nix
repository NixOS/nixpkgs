{ stdenv, buildPythonPackage, fetchPypi
, secretstorage
, fs, gdata, python_keyczar, pyasn1, pycrypto, six, setuptools_scm
, mock, pytest, pytestrunner }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "keyring";
  version = "11.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4607520a7c97be96be4ddc00f4b9dac65f47a45af4b4cd13ed5a8879641d646";
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
