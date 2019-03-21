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
  version = "0.28.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5999f327bfa6692679e82690c3e61f11097bbbe3ecee370210625676bac605e6";
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
