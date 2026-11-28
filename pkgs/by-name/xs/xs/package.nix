{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenvNoCC,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "cablehead";
    repo = "xs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M6HDYwKmrQEzDVhgZkDh8PDABa7UOU+9Z/dQH8kCR5Q=";
  };

  cargoHash = "sha256-eK0VFbtI8ETfK7lJLaIUNTFuF4La9zVVGzki7DTgU4I=";

  # Darwin needs bindgenHook for libproc
  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    rustPlatform.bindgenHook
  ];
  checkFlags = [
    # call to ping probably blocked in nix-build sandbox
    "--skip=ping"
    "--skip=network"
  ];
  dontUseCargoParallelTests = true;
  __darwinAllowLocalNetworking = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first event streaming for building reactive workflows and automation";
    homepage = "https://github.com/cablehead/xs";
    changelog = "https://github.com/cablehead/xs/blob/v${finalAttrs.version}/changes/v${finalAttrs.version}.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      schlich
    ];
    mainProgram = "xs";
  };
})
