{ lib, rustPlatform, fetchFromGitHub, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gHG8jk23qTANbLNPH4Q+YusEkDZ/G33SARAsLVLrVPs=";
  };

  cargoSha256 = "sha256-keu9lNYuOruU58YBPyqtDqBS/jjruK9GcYrKv7dGmlQ=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    changelog = "https://github.com/lunatic-solutions/lunatic/blob/v${version}/RELEASES.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
