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
  version = "0.30.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03n9ahf4qiyamblh217m5bjc8n57gh09xz87l2iw84c81xxdfcpg";
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
