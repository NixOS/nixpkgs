{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "kind2";
  version = "0.2.77";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-drWAWiSALq8rb3J2phNE/dt4e6xmJY7Ob8cES1kYEPo=";
  };

  cargoSha256 = "sha256-rF0TvNWE90sUqslBGPnGmD6mZFPlCCkM1jyuFt8n8Nw=";

  meta = with lib; {
    description = "A functional programming language and proof assistant";
    homepage = "https://github.com/kindelia/kind2";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
