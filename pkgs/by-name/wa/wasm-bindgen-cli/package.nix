{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
  nodejs_latest,
  pkg-config,
  openssl,
  stdenv,
  curl,
  darwin,
  version ? "0.2.93",
  hash ? "sha256-DDdu5mM3gneraM85pAepBXWn3TMofarVR4NbjMdz3r0=",
  cargoHash ? "sha256-birrg+XABBHHKJxfTKAMSlmTVYLmnmqMDfRnmG6g/YQ=",
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  inherit version hash cargoHash;

  src = fetchCrate { inherit pname version hash; };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      curl
      darwin.apple_sdk.frameworks.Security
    ];

  nativeCheckInputs = [ nodejs_latest ];

  # tests require it to be ran in the wasm-bindgen monorepo
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with lib.maintainers; [ rizary ];
    mainProgram = "wasm-bindgen";
  };
}
