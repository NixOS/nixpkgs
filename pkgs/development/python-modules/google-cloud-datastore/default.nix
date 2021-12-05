{ lib, buildPythonPackage, fetchPypi, google-api-core, google-cloud-core, libcst
, proto-plus, mock, pytestCheckHook, pytest-asyncio, google-cloud-testutils }:

buildPythonPackage rec {
  pname = "google-cloud-datastore";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a6f04112f2685a0a5cd8c7cb7946572bb7e0f6ca7cbe0088514006fca8594ca";
  };

  propagatedBuildInputs =
    [ google-api-core google-cloud-core libcst proto-plus ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

  preCheck = ''
    # directory shadows imports
    rm -r google
  '';

  disabledTestPaths = [
    # Requires credentials
    "tests/system/test_allocate_reserve_ids.py"
    "tests/system/test_query.py"
    "tests/system/test_put.py"
    "tests/system/test_transaction.py"
  ];

  pythonImportsCheck = [
    "google.cloud.datastore"
    "google.cloud.datastore_admin_v1"
    "google.cloud.datastore_v1"
  ];

  meta = with lib; {
    description = "Google Cloud Datastore API client library";
    homepage = "https://github.com/googleapis/python-datastore";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
