{ lib, rustPlatform, fetchFromGitHub, cmake, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MfN4NZIkzQji+bIfpgDdVyGXiD291ULGT2JslSevr/w=";
  };

  cargoSha256 = "sha256-Qpu6FKIrDZyEbcv/uRjInz6lmMeTSZvY/JGLJe+My+U=";

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
