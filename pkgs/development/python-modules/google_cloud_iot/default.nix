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
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ead560b0701cf1fe11fe15fae68f09460f0d04fbafa0965fb6bd9e60775437c";
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
