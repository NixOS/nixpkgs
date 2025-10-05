{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tailspin";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    tag = finalAttrs.version;
    hash = "sha256-coatx8Ud6iLnXvr+/X9hUEe3+0j9jnP5N3+aHQ+eWV8=";
  };

  cargoHash = "sha256-7N/vkhytkDF2ef0T6RJv8YzCpjzi+hjg061Uz9dyEM0=";

  postPatch = ''
    substituteInPlace tests/utils.rs --replace-fail \
      'target/debug' "target/${stdenv.hostPlatform.rust.rustcTargetSpec}/$cargoCheckType"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/tspin";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "tspin";
  };
})
