{ stdenv
, buildPythonPackage
, fetchPypi
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
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "621e05321d7a26b87fa2d4f8dd24f963d3424d7566a6454d65c4427b9d8552e2";
  };

  checkInputs = [ pytest mock ipython ];
  propagatedBuildInputs = [ google_resumable_media google_api_core google_cloud_core pandas pyarrow ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google BigQuery API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
