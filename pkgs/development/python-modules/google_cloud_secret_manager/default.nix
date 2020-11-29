{ lib, buildPythonPackage, fetchPypi
, grpc_google_iam_v1, google_api_core
, pytest, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2b0c93b559c3b6eb2dc75f7ab33d49fad8fe954f6094ac2b14323ce053058f0";
  };

  propagatedBuildInputs = [
    google_api_core
    grpc_google_iam_v1
  ];

  checkInputs = [
    mock
    pytest
  ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Secret Manager API: Stores, manages, and secures access to application secrets";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
