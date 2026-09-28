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
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    tag = finalAttrs.version;
    hash = "sha256-9+uu9q9tGIWFnyYpy+HHD5UUCsxUDLRlZlo0Ap4ezsY=";
  };

  cargoHash = "sha256-C3OORW5aeDrRDTlfvRNW3RLE0p8wFs1qbIKl/XpzThs=";

  postPatch = ''
    substituteInPlace tests/utils.rs --replace-fail \
      'target/debug' "target/${stdenv.hostPlatform.rust.rustcTargetSpec}/$cargoCheckType"
  '';

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
