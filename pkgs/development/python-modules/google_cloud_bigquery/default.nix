{ stdenv
, buildPythonPackage
, fetchPypi
, freezegun
, google_resumable_media
, google_api_core
, google_cloud_core
, pandas
, pyarrow
, pytest
, mock
, ipython
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery";
  version = "1.26.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51c29b95d460486d9e0210f63e8193691cd08480b69775270e84dd3db87c1bf2";
  };

  checkInputs = [ pytest mock ipython freezegun ];
  propagatedBuildInputs = [ google_resumable_media google_api_core google_cloud_core pandas pyarrow ];

  # prevent local directory from shadowing google imports
  # call_api_applying_custom_retry_on_timeout requires credentials
  # test_magics requires modifying sys.path
  checkPhase = ''
    rm -r google
    pytest tests/unit \
      -k 'not call_api_applying_custom_retry_on_timeout' \
      --ignore=tests/unit/test_magics.py
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Google BigQuery API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
