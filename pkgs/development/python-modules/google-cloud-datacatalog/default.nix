{ lib, buildPythonPackage, fetchPypi, libcst, google-api-core, grpc-google-iam-v1, proto-plus, pytest-asyncio, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2faca51e974c46203c09fd4cb2c03fd6e82cd572cc06a2bbc3b401aa419cb09f";
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
