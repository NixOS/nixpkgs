{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, freezegun
, google-cloud-core
, google-cloud-storage
, google-cloud-testutils
, google-resumable-media
, ipython
, mock
, pandas
, proto-plus
, psutil
, pyarrow
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery";
  version = "2.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8f8464188e3eb03925a4f4acbf4e8fbfbde84a06145bd8a52c6b736113713ae";
  };

  propagatedBuildInputs = [
    google-resumable-media
    google-cloud-core
    proto-plus
    pyarrow
  ];

  checkInputs = [
    freezegun
    google-cloud-testutils
    ipython
    mock
    pandas
    psutil
    google-cloud-storage
    pytestCheckHook
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  disabledTests = [
    # requires credentials
    "test_bigquery_magic"
    "TestBigQuery"
  ];

  pythonImportsCheck = [
    "google.cloud.bigquery"
    "google.cloud.bigquery_v2"
  ];

  meta = with lib; {
    description = "Google BigQuery API client library";
    homepage = "https://github.com/googleapis/python-bigquery";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
