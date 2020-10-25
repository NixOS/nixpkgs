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
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ab0128be96a01c6ba3d10db21b8018583b15995ad9a088cb3e4c3df90a62e46";
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
