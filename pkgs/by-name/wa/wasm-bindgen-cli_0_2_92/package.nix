{
  buildWasmBindgenCli,
  fetchCrate,
  rustPlatform,
}:

buildWasmBindgenCli rec {
  src = fetchCrate {
    pname = "wasm-bindgen-cli";
    version = "0.2.92";
    hash = "sha256-1VwY8vQy7soKEgbki4LD+v259751kKxSxmo/gqE6yV0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit (src) pname version;
    hash = "sha256-81vQkKubMWaX0M3KAwpYgMA1zUQuImFGvh5yTW+rIAs=";
  };
}
