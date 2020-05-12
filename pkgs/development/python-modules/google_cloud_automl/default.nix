{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, google_cloud_storage
, pandas
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-automl";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "031331fs97jpyxacwsmhig0ndidn97r288qnkrzfdvg1wxw5rdhi";
  };

  checkInputs = [ pandas pytest mock google_cloud_storage ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  # ignore tests which need credentials
  checkPhase = ''
    pytest tests/unit -k 'not upload and not prediction_client_client_info'
  '';

  meta = with stdenv.lib; {
    description = "Cloud AutoML API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
