{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-videointelligence";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd0abc18070520fd5757b15356e8483149e1caebbe43019257ccb2c43cddbbbe";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Video Intelligence API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
