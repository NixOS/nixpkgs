{ lib
, buildPythonPackage
, certifi
, cryptography
, fetchPypi
, openssl
, pylsqpack
, pyopenssl
, pytestCheckHook
, pythonOlder
, setuptools
, service-identity
}:

buildPythonPackage rec {
  pname = "aioquic";
  version = "0.9.25";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cHlceJBTJthVwq5SQHIjSq5YbHibgSkuJy0CHpsEMKM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    certifi
    cryptography
    pylsqpack
    pyopenssl
    service-identity
  ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioquic"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Implementation of QUIC and HTTP/3";
    homepage = "https://github.com/aiortc/aioquic";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
