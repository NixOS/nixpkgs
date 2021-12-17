{ lib, rustPlatform, fetchFromGitHub, cmake, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+4014p+4QJ7nytFHHszAOYQHXLYXqR+Cip+vHxsH9l8=";
  };

  cargoSha256 = "sha256-RnaAiumTP4cW2eHUbnwyPdgJQLK65gqDI/NP2SOrO4E=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    changelog = "https://github.com/lunatic-solutions/lunatic/blob/v${version}/RELEASES.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
    broken = stdenv.isDarwin;
  };
}
