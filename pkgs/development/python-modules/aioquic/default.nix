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

  pythonImportsCheck = [ "aioquic" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Implementation of QUIC and HTTP/3";
    homepage = "https://github.com/aiortc/aioquic";
    changelog = "https://github.com/aiortc/aioquic/blob/${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
