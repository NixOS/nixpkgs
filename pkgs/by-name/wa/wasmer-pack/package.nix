{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmer-pack";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer-pack";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9dIdwDKQyut2n1hgq4QzNZuGmGb1wUSmTJf9no6XI5A=";
  };

  cargoHash = "sha256-Hz+cvi82K9NJrn2yEkrVa29yhDUiE1gXZOwHFPljqqw=";

  cargoBuildFlags = [ "-p=wasmer-pack-cli" ];

  # requires internet access
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Import your WebAssembly code just like any other dependency";
    mainProgram = "wasmer-pack";
    homepage = "https://github.com/wasmerio/wasmer-pack";
    changelog = "https://github.com/wasmerio/wasmer-pack/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
