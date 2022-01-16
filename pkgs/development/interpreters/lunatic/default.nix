{ lib, rustPlatform, fetchFromGitHub, cmake, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RX8JarGpY6dhPGpvOX1FuUjirEPff0wGqLkGFxOa+bc=";
  };

  cargoSha256 = "sha256-UvrDqxaZSgUJ/a6abigTuiUOfw+C7UolBApt5kVR+yo=";

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
