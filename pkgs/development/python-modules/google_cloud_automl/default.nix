{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytestCheckHook, libcst
, google_api_core, google_cloud_storage, google_cloud_testutils, pandas
, proto-plus, pytest-asyncio, mock }:

buildPythonPackage rec {
  pname = "google-cloud-automl";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "520dfe2ee04d28f3088c9c582fa2a534fc272647d5e2e59acc903c0152e61696";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [
    google_cloud_storage
    google_cloud_testutils
    mock
    pandas
    pytest-asyncio
    pytestCheckHook
  ];
  propagatedBuildInputs = [ google_api_core libcst proto-plus ];

  # ignore tests which need credentials
  disabledTests = [ "test_prediction_client_client_info" ];
  preCheck = ''
    rm -r google
    rm tests/system/gapic/v1beta1/test_system_tables_client_v1.py
  '';

  meta = with stdenv.lib; {
    description = "Cloud AutoML API client library";
    homepage = "https://github.com/googleapis/python-automl";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
