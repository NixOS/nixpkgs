{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, grpc_google_iam_v1
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-securitycenter";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ef386ba065a167670ad1b67f15fb7ba9e21ce33579fa6d7fafafd5b970b3e8a";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Security Command Center API API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
