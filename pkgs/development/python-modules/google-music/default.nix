{ lib, buildPythonPackage, fetchPypi, pythonOlder
, appdirs
, audio-metadata
, google-music-proto
, httpx
, protobuf
, requests_oauthlib
, tenacity
}:

buildPythonPackage rec {
  pname = "google-music";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b79956cc0df86345c74436ae6213b700345403c91d51947288806b174322573b";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "audio-metadata>=0.8,<0.9" "audio-metadata"
  '';

  propagatedBuildInputs = [
    appdirs
    audio-metadata
    google-music-proto
    httpx
    protobuf
    requests_oauthlib
    tenacity
  ];

  # No tests
  doCheck = false;

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = "https://github.com/thebigmunch/google-music";
    description = "A Google Music API wrapper";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
