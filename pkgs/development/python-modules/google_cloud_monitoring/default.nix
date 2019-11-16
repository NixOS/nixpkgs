{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pandas
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-monitoring";
  version = "0.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cba63744faeea3b0167a752268955df127736e453820f01cc24e97bf4ae83c24";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core pandas ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Monitoring API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
