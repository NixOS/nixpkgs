{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, grpc_google_iam_v1
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-iot";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8af2be9c74697a350d5cc8ead00ae6cb4e85943564f1d782e8060d0d5eb15723";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud IoT API API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
