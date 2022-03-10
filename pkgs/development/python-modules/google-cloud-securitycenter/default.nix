{ lib
, buildPythonPackage
, fetchPypi
, grpc-google-iam-v1
, google-api-core
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-securitycenter";
  version = "1.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VaU6DRkq1pOESSOSynRRjaljp68C1X2H8anjHeHorbI=";
  };

  propagatedBuildInputs = [
    grpc-google-iam-v1
    google-api-core
    libcst
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.securitycenter"
    "google.cloud.securitycenter_v1"
    "google.cloud.securitycenter_v1beta1"
    "google.cloud.securitycenter_v1p1beta1"
  ];

  meta = with lib; {
    description = "Cloud Security Command Center API API client library";
    homepage = "https://github.com/googleapis/python-securitycenter";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
