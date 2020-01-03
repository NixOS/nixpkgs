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
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c6cb11d56dfe2cfb95f3083ed4c1347dafbf15a88fc9a7aab3ed5ee4c75cc40";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "audio-metadata>=0.3,<0.4" "audio-metadata"
  '';

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
