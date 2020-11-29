{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
, mock
, libcst
, proto-plus
}:

buildPythonPackage rec {
  pname = "google-cloud-dataproc";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81c44ac114c94df8f5b21245e5e7fc4eabce66b25fc432c3696b62b5de143b1f";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core libcst proto-plus ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Dataproc API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
