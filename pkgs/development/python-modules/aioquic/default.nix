{
  lib,
  stdenv,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchPypi,
  openssl,
  pylsqpack,
  pyopenssl,
  pytestCheckHook,
  setuptools,
  service-identity,
}:

buildPythonPackage rec {
  pname = "aioquic";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KNBwshg+PnmvqdTnvVWJYNDVOuuYvAzwo1iyebp5fJI=";
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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # QUIC needs UDP/multicast not available in sandbox.
    "test_connect_and_serve_ipv4"
  ];

  pythonImportsCheck = [ "aioquic" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Implementation of QUIC and HTTP/3";
    homepage = "https://github.com/aiortc/aioquic";
    changelog = "https://github.com/aiortc/aioquic/blob/${version}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
