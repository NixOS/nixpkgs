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
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04f0a2bb53d779fc62927be92f8253c34774a1a9f95cccec3e45d000d1547ef9";
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
