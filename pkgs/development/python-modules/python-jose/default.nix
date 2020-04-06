{ stdenv, buildPythonPackage, fetchFromGitHub
, future, six, ecdsa, rsa
, pycrypto, pytest, pytestcov, pytestrunner, cryptography
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
    pytest
    pytestcov
    pytestrunner
    cryptography # optional dependency, but needed in tests
  ];
  checkPhase = ''
    py.test
  '';

  # https://github.com/mpdavis/python-jose/issues/149
  PYTEST_ADDOPTS = "-k 'not test_invalid_claims_json and not test_invalid_claims'";

  propagatedBuildInputs = [ future six ecdsa rsa ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mpdavis/python-jose;
    description = "A JOSE implementation in Python";
    license = licenses.mit;
    maintainers = [ maintainers.jhhuh ];
  };
}
