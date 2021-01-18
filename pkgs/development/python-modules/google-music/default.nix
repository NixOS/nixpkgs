{ lib
, buildPythonPackage
, fetchPypi
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
    sha256 = "0fsp491ifsw0i1r98l8xr41m8d00nw9n5bin8k3laqzq1p65d6dp";
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

  meta = with lib; {
    homepage = "https://github.com/thebigmunch/google-music";
    description = "A Google Music API wrapper";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
