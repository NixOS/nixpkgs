{ stdenv, buildPythonPackage, fetchFromGitHub
, future, six, ecdsa, rsa
, pycrypto, pytest, pytestcov, pytestrunner, cryptography
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    rev = version;
    sha256 = "1ahq4m86z504bnlk9z473r7r3dprg5m39900rld797hbczdhqa4f";
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

  postPatch = ''
    # File says it's utf-8 so instead of relying on the environment, fix the decoding when reading.
    substituteInPlace setup.py --replace "open('README.md')" "open('README.md',encoding='utf-8')"
  '';

  propagatedBuildInputs = [ future six ecdsa rsa ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mpdavis/python-jose;
    description = "A JOSE implementation in Python";
    license = licenses.mit;
    maintainers = [ maintainers.jhhuh ];
  };
}
