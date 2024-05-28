{
  lib,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchPypi,
  openssl,
  pylsqpack,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  service-identity,
}:

buildPythonPackage rec {
  pname = "aioquic";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7THCta+pjFtsr6TzYUnerx3/bFppcB6t0nFnQV+fFmA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    cryptography
    pylsqpack
    pyopenssl
    service-identity
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aioquic" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Implementation of QUIC and HTTP/3";
    homepage = "https://github.com/aiortc/aioquic";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
