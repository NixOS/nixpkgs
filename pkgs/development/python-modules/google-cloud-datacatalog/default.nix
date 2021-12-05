{ lib, buildPythonPackage, fetchPypi, libcst, google-api-core
, grpc-google-iam-v1, proto-plus, pytest-asyncio, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4a3ba5bc93fb38008077335546daef9f5ea59a1b3accb98b0d07ca7fe6c6e37";
  };

  propagatedBuildInputs =
    [ libcst google-api-core grpc-google-iam-v1 proto-plus ];

  checkInputs = [ pytest-asyncio pytestCheckHook mock ];

  pythonImportsCheck = [ "google.cloud.datacatalog" ];

  meta = with lib; {
    description = "Google Cloud Data Catalog API API client library";
    homepage = "https://github.com/googleapis/python-datacatalog";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
