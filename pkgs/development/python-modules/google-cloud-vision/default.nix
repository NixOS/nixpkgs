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
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65ed06725377670fc1b21d474237922f29674d0f99a472b0c84683aa02af70a4";
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
