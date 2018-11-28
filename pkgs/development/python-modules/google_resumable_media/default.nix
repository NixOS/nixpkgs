{ stdenv
, buildPythonPackage
, fetchPypi
, six
, requests
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97de518f8166d442cc0b61fab308bcd319dbb970981e667ec8ded44f5ce49836";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ six requests ];

  checkPhase = ''
    py.test tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Utilities for Google Media Downloads and Resumable Uploads";
    homepage = https://github.com/GoogleCloudPlatform/google-resumable-media-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
