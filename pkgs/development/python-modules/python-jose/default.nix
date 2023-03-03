{ lib
, buildPythonPackage
, fetchFromGitHub
, ecdsa
, rsa
, pycrypto
, pyasn1
, pycryptodome
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = pname;
    rev = version;
    hash = "sha256-6VGC6M5oyGCOiXcYp6mpyhL+JlcYZKIqOQU9Sm/TkKM=";
  };

  propagatedBuildInputs = [
    cryptography
    ecdsa
    pyasn1
    pycrypto
    pycryptodome
    rsa
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  pythonImportsCheck = [ "jose" ];

  meta = with lib; {
    homepage = "https://github.com/mpdavis/python-jose";
    description = "A JOSE implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jhhuh ];
  };
}
