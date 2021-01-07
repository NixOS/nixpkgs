{ stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, freezegun
, google-cloud-core
, google-cloud-testutils
, google-resumable-media
, grpcio
, ipython
, mock
, pandas
, proto-plus
, pyarrow
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vs4im0fixmszh6p77icys9g7fymwmkfc6va0ng9kpjv1h6gv68z";
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
    pytestCheckHook
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.bigquery"
    "google.cloud.bigquery_v2"
  ];

  meta = with stdenv.lib; {
    description = "Google BigQuery API client library";
    homepage = "https://github.com/googleapis/python-bigquery";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
