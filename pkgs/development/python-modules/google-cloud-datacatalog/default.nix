{ lib, buildPythonPackage, fetchPypi, libcst, google-api-core, grpc-google-iam-v1, proto-plus, pytest-asyncio, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f16ff1bb49ff760cdc0ff30bbc352f0c27b8bdd2ba76d8bf22e0fd9af3a2ca16";
  };

  propagatedBuildInputs = [ libcst google-api-core grpc-google-iam-v1 proto-plus ];

  checkInputs = [ pytest-asyncio pytestCheckHook mock ];

  pythonImportsCheck = [ "google.cloud.datacatalog" ];

  meta = with lib; {
    description = "Google Cloud Data Catalog API API client library";
    homepage = "https://github.com/googleapis/python-datacatalog";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
