{
  lib,
  rustPlatform,
  fetchFromGitHub,
  procps,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tailspin";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    tag = finalAttrs.version;
    hash = "sha256-RI604v8ImQSgvNUGsnCLe6FuzEMJwE0tNVuFLmJLwvM=";
  };

  cargoHash = "sha256-kcd6rBoonoCKuybVIVtZqt+njHFhVDTjTyF2UURuOSI=";

  nativeCheckInputs = [ procps ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/tspin";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tspin";
  };
})
