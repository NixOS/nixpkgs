{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, grpc_google_iam_v1
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "add648f9185a8724f8632b3a006ee0af4847a5ab4ca085954ff1d00a8cd2d54c";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Key Management Service (KMS) API API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
