{ lib, buildPythonPackage, fetchPypi, google-api-core, google-cloud-core
, google-cloud-testutils, mock, proto-plus, pytestCheckHook, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-trace";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd4cb8a9efa20598c35a4e6f7ac013a04868e37d7d4ff4ec3080f528b06f8a0e";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core proto-plus ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # require credentials
    "test_batch_write_spans"
    "test_list_traces"
  ];

  pythonImportsCheck =
    [ "google.cloud.trace" "google.cloud.trace_v1" "google.cloud.trace_v2" ];

  meta = with lib; {
    description = "Cloud Trace API client library";
    homepage = "https://github.com/googleapis/python-trace";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
