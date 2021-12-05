{ lib, buildPythonPackage, fetchPypi, google-api-core, libcst, mock, proto-plus
, pytestCheckHook, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-vision";
  version = "2.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "542a300f4b79ed9574cdeb4eb47cf8899f0915041e8bf0058e8192a620087d30";
  };

  propagatedBuildInputs = [ libcst google-api-core proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [
    "google.cloud.vision"
    "google.cloud.vision_helpers"
    "google.cloud.vision_v1"
    "google.cloud.vision_v1p1beta1"
    "google.cloud.vision_v1p2beta1"
    "google.cloud.vision_v1p3beta1"
    "google.cloud.vision_v1p4beta1"
  ];

  meta = with lib; {
    description = "Cloud Vision API API client library";
    homepage = "https://github.com/googleapis/python-vision";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
