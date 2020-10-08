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
  version = "0.30.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de7eba5235df61deee2291a2fe70b904154df613a334109488afdea7a4c0011f";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_cloud_core google_api_core ];

  checkPhase = ''
    rm -r google
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Resource Manager API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
