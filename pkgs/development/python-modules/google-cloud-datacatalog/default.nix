{ lib, buildPythonPackage, fetchPypi, libcst, google-api-core, grpc-google-iam-v1, proto-plus, pytest-asyncio, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9oixM+4HxHn0G3j8Hpg1iB5gM+7xyD5GBbWpEzzjdrE=";
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
