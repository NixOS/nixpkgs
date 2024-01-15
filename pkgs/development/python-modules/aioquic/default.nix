{ lib
, buildPythonPackage
, certifi
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
  version = "0.9.23";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UsnaYO0IN/6LimoNfc8N++vsjpoCfhDr9yBPBWnFj6g=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    certifi
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
