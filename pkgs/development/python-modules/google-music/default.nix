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
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15d543ab31c981bcb9bfb10f588159848ef570fafb6b9d1347f1429a9b1f531a";
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
