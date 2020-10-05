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
  pname = "google-cloud-asset";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2386261f3ca7a4fb9c4ef3b5ddc8e9b7851e770ec43f12bc4751ddfd93a2793";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Asset API API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
