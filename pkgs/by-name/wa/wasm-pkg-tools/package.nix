{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-pkg-tools";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-pkg-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VZ+rUZi6o2onMFxK/BMyi6ZjuDS0taJh5w3r33KCZTU=";
  };

  cargoHash = "sha256-dHhJT/edEYagLQoUcXCLPA4fUJdN9ZoOITLpWAH5p/0=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  checkFlags = [
    "--skip=build_and_publish_with_metadata"
    "--skip=publish_and_fetch_smoke_test"
    "--skip=test_fetch::case_1::output_1_OutputType__Wasm"
    "--skip=test_fetch::case_1::output_2_OutputType__Wit"
    "--skip=test_fetch::case_2::output_1_OutputType__Wasm"
    "--skip=test_fetch::case_2::output_2_OutputType__Wit"
  ];
  versionCheckProgram = "${placeholder "out"}/bin/wkg";

  meta = {
    description = "Tools to package up WebAssembly components";
    homepage = "https://github.com/bytecodealliance/wasm-pkg-tools";
    changelog = "https://github.com/bytecodealliance/wasm-pkg-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "wkg";
  };
})
