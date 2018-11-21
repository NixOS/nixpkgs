{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-dataproc";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "531dbd3e5862df5e67751efdcd89f00d0ded35f3a87a18fd3245e1c365080720";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Dataproc API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
