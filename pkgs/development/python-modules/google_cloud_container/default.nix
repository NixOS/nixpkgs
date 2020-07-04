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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9dd4523291401d8d872f89a87fa5a1d2bcbf6b8ceb1ec0659098fec37d9250e4";
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
