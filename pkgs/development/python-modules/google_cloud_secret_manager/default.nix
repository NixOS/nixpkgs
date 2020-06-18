{ lib, buildPythonPackage, fetchPypi
, grpc_google_iam_v1, google_api_core
, pytest, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cm3xqacxnbpv2706bd2jl86mvcsphpjlvhzngz2k2p48a0jjx8r";
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
