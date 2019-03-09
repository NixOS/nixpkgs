{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-language";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4742b98e2d69ca21864e3218805a9db7e04e06f0672f2385cf6b5361ee35605";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Natural Language API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
