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
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b274fb5d38cfaa556a07943d9c9a23ca4aa3ecca51135a70325e1c95fa699474";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud IoT API API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
