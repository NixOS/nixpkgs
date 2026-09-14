{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "turm";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "karimknaebel";
    repo = "turm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K83jfPQORE0MQiyeHfWxtp1BhVAS15o3sbd5Vp75GCU=";
  };

  cargoHash = "sha256-G9CeueyNB+jJ1veAb80m3uRBHhJ15jc0y4rxO2Rvuhs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for the Slurm Workload Manager";
    homepage = "https://github.com/karimknaebel/turm";
    changelog = "https://github.com/karimknaebel/turm/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nemeott ];
    mainProgram = "turm";
  };
})
