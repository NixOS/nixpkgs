{ lib, buildPythonPackage, fetchPypi, pythonOlder
, appdirs
, audio-metadata
, google-music-proto
, protobuf
, requests_oauthlib
, tenacity
}:

buildPythonPackage rec {
  pname = "google-music";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13i9nd62wqfg0f5r7ykr15q83397vdpw0js50fy5nbgs33sbf6b7";
  };

  propagatedBuildInputs = [
    appdirs
    audio-metadata
    google-music-proto
    protobuf
    requests_oauthlib
    tenacity
  ];

  # No tests
  doCheck = false;

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music;
    description = "A Google Music API wrapper";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
