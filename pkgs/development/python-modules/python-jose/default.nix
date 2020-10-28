{ stdenv, buildPythonPackage, fetchFromGitHub
, future, six, ecdsa, rsa
, pycrypto, pytestcov, pytestrunner, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    rev = version;
    sha256 = "cSPIZrps0xFd4pPcQ4w/jFWOk2XYgd3mtE/sDzlytvY=";
  };

  checkInputs = [
    pycrypto
    pytestCheckHook
    pytestcov
    pytestrunner
    cryptography # optional dependency, but needed in tests
  ];

  # relax ecdsa deps
  patchPhase = ''
    substituteInPlace setup.py \
      --replace 'ecdsa<0.15' 'ecdsa' \
      --replace 'ecdsa <0.15' 'ecdsa'
  '';

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
