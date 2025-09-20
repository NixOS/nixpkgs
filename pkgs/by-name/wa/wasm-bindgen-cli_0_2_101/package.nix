{
  buildWasmBindgenCli,
  fetchCrate,
  rustPlatform,
}:

buildWasmBindgenCli rec {
  src = fetchCrate {
    pname = "wasm-bindgen-cli";
    version = "0.2.101";
    hash = "sha256-txpbTzlrPSEktyT9kSpw4RXQoiSZHm9t3VxeRn//9JI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit (src) pname version;
    hash = "sha256-J+F9SqTpH3T0MbvlNKVyKnMachgn8UXeoTF0Pk3Xtnc=";
  };
}
