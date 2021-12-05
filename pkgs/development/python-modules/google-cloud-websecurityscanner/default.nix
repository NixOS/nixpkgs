{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, google-api-core, libcst
, mock, proto-plus, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-websecurityscanner";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "392a21dd238958eb7f480d056ed24110be22808cf4474939db40df0ade2910f3";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [ mock pytest-asyncio pytestCheckHook ];

  pythonImportsCheck = [
    "google.cloud.websecurityscanner_v1alpha"
    "google.cloud.websecurityscanner_v1beta"
  ];

  meta = with lib; {
    description = "Google Cloud Web Security Scanner API client library";
    homepage = "https://github.com/googleapis/python-websecurityscanner";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
