{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, mock
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-dataproc";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a81HBeNoLXSpJJJ0BBqJz24ls0TFMwiHJgkkNyHZGvo=";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_clusters"
  ];

  pythonImportsCheck = [
    "google.cloud.dataproc"
    "google.cloud.dataproc_v1"
  ];

  meta = with lib; {
    description = "Google Cloud Dataproc API client library";
    homepage = "https://github.com/googleapis/python-dataproc";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
