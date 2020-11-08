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
  pname = "google-cloud-securitycenter";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14ebad262cd01c9a3998561684617be2e97ad5d27dab1918c14b964f97e1f8f7";
  };

  checkInputs = [ pytest mock ];
  requiredPythonModules = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Security Command Center API API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
