{
  lib,
  fetchFromGitHub,
  git,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weave";
  version = "0.5.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ataraxy-labs";
    repo = "weave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-en8HwzvC2uPBwyHnQyUHrRLvWyWDWPptfTpX353i/pU=";
  };

  cargoHash = "sha256-LYcHCc3OkBmWY9tSpm3Mp+Dw/CRoTICngL7+GkUDAHk=";

  cargoBuildFlags = [
    "--bin"
    "weave"

    "--bin"
    "weave-driver"

    "--bin"
    "weave-mcp"
  ];

  cargoTestFlags = [
    "--package"
    "weave-cli"

    "--package"
    "weave-driver"

    "--package"
    "weave-mcp"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # crates/weave-driver/tests/public_properties.rs, added after 0.3.6,
  # shells out to git to build a conflicted merge and then abort it.
  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Entity-level semantic merge driver for Git";
    homepage = "https://ataraxy-labs.github.io/weave/";
    changelog = "https://github.com/ataraxy-labs/weave/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ malix ];
    mainProgram = "weave";
  };
})
