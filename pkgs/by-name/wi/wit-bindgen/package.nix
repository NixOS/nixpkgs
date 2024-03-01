{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wit-bindgen";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wit-bindgen";
    rev = "v${version}";
    hash = "sha256-8z6WgKahb01A9RAJsmavgGAeXkh6Hcr6qnzLhcfuHbw=";
  };

  cargoHash = "sha256-v14p4b2nUFtXs15b3zmYKAG1am+KDRfw2MfrjNQFjvw=";

  # Some tests fail because they need network access to install the `wasm32-unknown-unknown` target.
  # However, GitHub Actions ensures a proper build.
  # See also:
  #   https://github.com/bytecodealliance/wit-bindgen/actions
  #   https://github.com/bytecodealliance/wit-bindgen/blob/main/.github/workflows/main.yml
  doCheck = false;

  meta = with lib; {
    description = "A language binding generator for WebAssembly interface types";
    homepage = "https://github.com/bytecodealliance/wit-bindgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "wit-bindgen";
  };
}
