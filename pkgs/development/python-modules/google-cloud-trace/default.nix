{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, google-cloud-testutils
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-trace";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bae81c127520af3c03183822e9a3c30aa90b030f2b8e66f64485abf7f2af8ff9";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core proto-plus ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # require credentials
    "test_batch_write_spans"
    "test_list_traces"
  ];

  pythonImportsCheck = [
    "google.cloud.trace"
    "google.cloud.trace_v1"
    "google.cloud.trace_v2"
  ];

  meta = with lib; {
    description = "Cloud Trace API client library";
    homepage = "https://github.com/googleapis/python-trace";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
