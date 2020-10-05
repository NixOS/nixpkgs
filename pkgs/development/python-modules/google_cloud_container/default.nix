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
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd800230f51484d2ad59b7a6daea85c5497cf412c6b5623d53cafd4418c12c1f";
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
