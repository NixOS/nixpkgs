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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfd1511a7bcc7d23c2ea30253dd86b2b2247576d1345d895d7153dc0b262f06e";
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
