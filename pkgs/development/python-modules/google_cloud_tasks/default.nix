{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, grpc_google_iam_v1
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-tasks";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f874a7aabad225588263c6cbcd4d67455cc682ebb6d9f00bd06c8d2d5673b4db";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Tasks API API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
