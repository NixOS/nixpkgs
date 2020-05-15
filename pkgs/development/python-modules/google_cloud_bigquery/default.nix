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
  version = "1.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ca22hzql8x1z6bx9agidx0q09w24jwzkgg49k5j1spcignwxz3z";
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
    description = "Google BigQuery API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
