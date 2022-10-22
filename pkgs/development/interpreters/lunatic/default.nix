{ lib, rustPlatform, fetchFromGitHub, cmake, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MQ10WwvUdqU4w9uA4H1+VRM29HXVtLMwfGvbM6VqS90=";
  };

  cargoSha256 = "sha256-tNYA3YruI7VENmLbd3rmZr7BkqHp1HNOfzPTkIiixqA=";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  checkFlags = [
    # requires simd support which is not always available on hydra
    "--skip=state::tests::import_filter_signature_matches"
  ];

  meta = with lib; {
    description = "An Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    changelog = "https://github.com/lunatic-solutions/lunatic/blob/v${version}/RELEASES.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
