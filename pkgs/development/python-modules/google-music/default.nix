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
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1agqsbnn72gx88sk736k1pzdn2j8fi7flwqhj5g2qhz3wvkx90yq";
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
    homepage = https://github.com/thebigmunch/google-music;
    description = "A Google Music API wrapper";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
