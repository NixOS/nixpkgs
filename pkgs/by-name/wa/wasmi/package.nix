{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmi";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "wasmi-labs";
    repo = "wasmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oGuw8//jsmeTxwHli7EAy4+W/iB/kSW40DFLjObA4hg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-QhSY6VGtpy2s7Dmp+cm65PCkM4zoeJ/ZrjjEGVWLgm4=";

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient and versatile WebAssembly interpreter for embedded systems";
    homepage = "https://github.com/wasmi-labs/wasmi";
    changelog = "https://github.com/wasmi-labs/wasmi/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "wasmi";
  };
})
