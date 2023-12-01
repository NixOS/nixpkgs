{ lib
, buildPythonPackage
, certifi
, cryptography
, fetchFromGitHub
, pylsqpack
, pyopenssl
, pytestCheckHook
, pythonOlder
, service-identity
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "aioquic-mitmproxy";
  version = "0.9.21.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "meitinger";
    repo = "aioquic_mitmproxy";
    rev = "refs/tags/${version}";
    hash = "sha256-eD3eICE9jS1jyqMgWwcv6w3gkR0EyGcKwgSXhasXNeA=";
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
    service-identity
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
