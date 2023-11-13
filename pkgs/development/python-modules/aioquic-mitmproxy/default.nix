{ lib
, buildPythonPackage
, certifi
, cryptography
, fetchFromGitHub
, pylsqpack
, pyopenssl
, pytestCheckHook
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "aioquic-mitmproxy";
  version = "0.9.20.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "meitinger";
    repo = "aioquic_mitmproxy";
    rev = "refs/tags/${version}";
    hash = "sha256-VcIbtrcA0dBEE52ZD90IbXoh6L3wDUbr2kFJikts6+w=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    certifi
    cryptography
    pylsqpack
    pyopenssl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioquic"
  ];

  meta = with lib; {
    description = "QUIC and HTTP/3 implementation in Python";
    homepage = "https://github.com/meitinger/aioquic_mitmproxy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
