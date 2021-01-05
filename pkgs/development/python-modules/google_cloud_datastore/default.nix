{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, libcst
, proto-plus
, mock
, pytestCheckHook
, pytest-asyncio
, google_cloud_testutils
}:

buildPythonPackage rec {
  pname = "google-cloud-datastore";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yyk9ix1jms5q4kk76cfxzy42wzzyl5qladdswjy5l0pg6iypr8i";
  };

  propagatedBuildInputs = [ google_api_core google_cloud_core libcst proto-plus ];

  checkInputs = [ google_cloud_testutils mock pytestCheckHook pytest-asyncio ];

  preCheck = ''
    # directory shadows imports
    rm -r google
    # requires credentials
    rm tests/system/test_system.py
  '';

  pythonImportsCheck = [
    "google.cloud.datastore"
    "google.cloud.datastore_admin_v1"
    "google.cloud.datastore_v1"
  ];

  meta = with stdenv.lib; {
    description = "Google Cloud Datastore API client library";
    homepage = "https://github.com/googleapis/python-datastore";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
