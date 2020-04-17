{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, grpc_google_iam_v1
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-container";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07zjwwliz8wx83l3bv7244qzrv0s3fchp8kgsy5xy41kmkg79a2d";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core grpc_google_iam_v1 ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Container Engine API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
