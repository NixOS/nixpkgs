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
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aacba434c54b1ecc83527d6fa06ffc0938a7af109e292ed1f2cfd56d567a0a29";
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
