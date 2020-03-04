{ stdenv
, buildPythonPackage
, fetchPypi
, google_cloud_core
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-resource-manager";
  version = "0.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e4f1d618d8934ee9011e97db940bb177770b430fd29e58848599a416d9f6590";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_cloud_core google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Resource Manager API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
