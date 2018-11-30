{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, grpc_google_iam_v1
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-iot";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1502fa6d64f8f0f7c0e34e71c82c5daacc8fd8f78256cfadef5ae06c5efcc3b4";
  };

  checkInputs = [ pytest ];
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
