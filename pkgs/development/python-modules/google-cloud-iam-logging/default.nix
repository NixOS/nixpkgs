{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc_google_iam_v1
, mock
, proto-plus
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-iam-logging";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19a8s634w2m1b16zq8f185cpaw7k6d0c7c61g1vzm19jl213rhiw";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc_google_iam_v1
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.iam_logging"
    "google.cloud.iam_logging_v1"
  ];

  meta = with lib; {
    description = "IAM Service Logging client library";
    homepage = "https://github.com/googleapis/python-iam-logging";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
