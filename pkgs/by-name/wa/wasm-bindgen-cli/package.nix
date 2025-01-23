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
  version ? "0.2.100",
  hash ? "sha256-3RJzK7mkYFrs7C/WkhW9Rr4LdP5ofb2FdYGz1P7Uxog=",
  cargoHash ? "sha256-tD0OY2PounRqsRiFh8Js5nyknQ809ZcHMvCOLrvYHRE=",
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  inherit version hash cargoHash;

  src = fetchCrate { inherit pname version hash; };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
