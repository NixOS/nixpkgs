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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f714e3d427e2b36d1365fc400f4d379972529fb40f798d9c0e06c7c3418fc89";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core grpc_google_iam_v1 ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Google Container Engine API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
