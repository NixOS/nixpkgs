{
  buildWasmBindgenCli,
  fetchCrate,
  rustPlatform,
}:

buildWasmBindgenCli rec {
  src = fetchCrate {
    pname = "wasm-bindgen-cli";
    version = "0.2.95";
    hash = "sha256-prMIreQeAcbJ8/g3+pMp1Wp9H5u+xLqxRxL+34hICss=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    inherit (src) pname version;
    hash = "sha256-6iMebkD7FQvixlmghGGIvpdGwFNLfnUcFke/Rg8nPK4=";
  };
}
