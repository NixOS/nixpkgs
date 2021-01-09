{ stdenv
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc_google_iam_v1
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-container";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04f9mx1wxy3l9dvzvvr579fnjp1fdqhgplv5y2gl7h2mvn281k8d";
  };

  propagatedBuildInputs = [ google-api-core grpc_google_iam_v1 libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_clusters"
  ];

  pythonImportsCheck = [
    "google.cloud.container"
    "google.cloud.container_v1"
    "google.cloud.container_v1beta1"
  ];

  meta = with stdenv.lib; {
    description = "Google Container Engine API client library";
    homepage = "https://github.com/googleapis/python-container";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
