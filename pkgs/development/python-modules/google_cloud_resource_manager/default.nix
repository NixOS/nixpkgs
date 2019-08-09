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
  version = "0.28.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae43be426532b875c161625626ab759ecef633801e21f14b2ef8380884a2193b";
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
