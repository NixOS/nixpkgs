{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-vision";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a205be275739c141873fa9fbd7c3f9ec6170972c85d5c75e9b4c53b5db839a3";
  };

  propagatedBuildInputs = [ libcst google-api-core proto-plus];

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
