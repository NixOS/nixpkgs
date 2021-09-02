{ lib, buildPythonPackage, fetchPypi, libcst, google-api-core, grpc-google-iam-v1, proto-plus, pytest-asyncio, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad1bf9991bdee2a2fee44d19e54790a6eb900652841a5d7a32aa1c468a196f49";
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
