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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    inherit (src) pname version;
    hash = "sha256-birrg+XABBHHKJxfTKAMSlmTVYLmnmqMDfRnmG6g/YQ=";
  };
}
