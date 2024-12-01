{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "webmetro";
  version = "unstable-20180426";

  src = fetchFromGitHub {
    owner = "Tangent128";
    repo = pname;
    rev = "4f6cc00fe647bd311d00a8a4cb53ab08f20a04f9";
    sha256 = "1n2c7ygs8qsd5zgii6fqqcwg427bsij082bg4ijnzkq5630dx651";
  };

  cargoHash = "sha256-6LfJ5rI7Y+ziEIMxPpKxOS+VSrKuKohEcqIK7xdKhNg=";

  meta = with lib; {
    description = "Simple relay server for broadcasting a WebM stream";
    longDescription = ''
    Webmetro is a simple relay server for broadcasting a WebM stream
    from one uploader to many downloaders, via HTTP.
    The initialization segment is remembered, so that viewers can join
    mid-stream.  Cluster timestamps are rewritten to be monotonic, so multiple
    (compatibly-encoded) webm files can be chained together without
    clients needing to reconnect.
    '';
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ leenaars ];
    mainProgram = "webmetro";
  };
}
