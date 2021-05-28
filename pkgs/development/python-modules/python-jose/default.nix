{ stdenv, buildPythonPackage, fetchFromGitHub
, future, six, ecdsa, rsa
, pycrypto, pytestcov, pytestrunner, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    rev = version;
    sha256 = "1gnn0zy03pywj65ammy3sd07knzhjv8n5jhx1ir9bikgra9v0iqh";
  };

  checkInputs = [
    pycrypto
    pytestCheckHook
    pytestcov
    pytestrunner
    cryptography # optional dependency, but needed in tests
  ];

  disabledTests = [
    # https://github.com/mpdavis/python-jose/issues/176
    "test_key_too_short"
  ];

  propagatedBuildInputs = [ future six ecdsa rsa ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mpdavis/python-jose";
    description = "A JOSE implementation in Python";
    license = licenses.mit;
    maintainers = [ maintainers.jhhuh ];
  };
}
