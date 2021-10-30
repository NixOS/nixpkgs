{ cmake, fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dz8v19jw9v55p3mz4932v6z24ihp6wk238n4d4lx9xj91mf3g6r";
  };

  cargoSha256 = "1rkxl27l6ydmcq3flc6qbnd7zmpkfmyc86b8q4pi7dwhqnd5g70g";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
