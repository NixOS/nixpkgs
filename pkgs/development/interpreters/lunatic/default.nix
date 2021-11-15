{ lib, rustPlatform, fetchFromGitHub, fetchpatch, cmake, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dz8v19jw9v55p3mz4932v6z24ihp6wk238n4d4lx9xj91mf3g6r";
  };

  cargoPatches = [
    # NOTE: remove on next update
    # update dependencies to resolve incompatibility with rust 1.56
    (fetchpatch {
      name = "update-wasmtime.patch";
      url = "https://github.com/lunatic-solutions/lunatic/commit/cd8db51732712c19a8114db290882d1bb6b928c0.patch";
      sha256 = "sha256-eyoIOTqGSU/XNfF55FG+WrQPSMvt9L/S/KBsUQB5z1k=";
    })
  ];

  cargoSha256 = "sha256-yoG4gCk+nHE8pBqV6ND9NCegx4bxbdGEU5hY5JauloM=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
    broken = stdenv.isDarwin;
  };
}
