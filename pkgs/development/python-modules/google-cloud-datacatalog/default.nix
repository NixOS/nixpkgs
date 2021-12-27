{ lib, buildPythonPackage, fetchPypi, libcst, google-api-core, grpc-google-iam-v1, proto-plus, pytest-asyncio, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "136fb153740d4154d8c9ef306284f7f899399de45eef2c9027ca3e56249c4e2d";
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
