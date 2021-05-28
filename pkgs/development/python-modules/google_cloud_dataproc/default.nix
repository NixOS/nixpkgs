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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6d94af6c0d5aee0bb88d058a180f4d3341209e112f85a1c7ce0df7887cbf867";
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
