{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weave";
  version = "0.3.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ataraxy-labs";
    repo = "weave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VlJUXAXlWpFGlJgAEhhdeX35AZV/G/IJlXEjU/7SfJg=";
  };

  cargoHash = "sha256-ZPe9l3S88idwYrayT5mmagW/VdA0VlUHTDXVyHoOF1w=";

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
