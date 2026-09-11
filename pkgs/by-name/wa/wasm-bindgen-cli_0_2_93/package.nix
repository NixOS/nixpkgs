{
  buildWasmBindgenCli,
  fetchCrate,
  rustPlatform,
}:

buildWasmBindgenCli rec {
  src = fetchCrate {
    pname = "wasm-bindgen-cli";
    version = "0.2.93";
    hash = "sha256-DDdu5mM3gneraM85pAepBXWn3TMofarVR4NbjMdz3r0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit (src) pname version;
    hash = "sha256-s8srI+lu+DgQ+5BbaEXC4Ja/BL+K22LIl5Gd1PwNZZk=";
  };
}
