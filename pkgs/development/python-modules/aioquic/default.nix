{ lib
, buildPythonPackage
, certifi
, cryptography
, fetchPypi
, fetchpatch
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

  patches = [
    (fetchpatch {
      url = "https://github.com/aiortc/aioquic/commit/e899593805e0b31325a1d347504eb8e6100fe87d.diff";
      hash = "sha256-TTpIIWX/R4k2KxhsN17O9cRW/dN0AARYnju8JTht3D8=";
    })
  ];

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
