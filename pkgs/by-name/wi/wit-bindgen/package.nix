{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wit-bindgen";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wit-bindgen";
    rev = "v${version}";
    hash = "sha256-rSPxvEZf4bnQfLNCmyZV7oOuhG/hRAcDs1zPmfovJ8o=";
  };

  cargoHash = "sha256-oHSsbGLz8OcAfLeNA1yqVVRHa0ZkE8UoJn795t8xxGs=";

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
