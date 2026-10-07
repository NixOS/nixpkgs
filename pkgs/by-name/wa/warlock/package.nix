{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "warlock";
  version = "0.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Genetic-Pottery";
    repo = "warlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xt3waRTEAsauCDTnYCj8gKOJMToSq6tpJL60UhrHEcg=";
  };

  cargoHash = "sha256-5kLF1wvsrhsCmlS5PmM9eLivOoLS2276e5RA8x2banE=";

  cargoBuildFlags = [
    "--package"
    "warlock-tui"
  ];
  cargoTestFlags = [ "--workspace" ];

  nativeCheckInputs = [ gitMinimal ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI that keeps AI-readable documentation of a codebase current";
    longDescription = ''
      Warlock writes a .warlock.md document for each directory of a
      repository and tracks whether each one is still true of the code
      beside it. It can also file briefs to Linear, cut them into tickets,
      and work tickets to pull requests.

      Warlock runs the `claude` command-line tool at runtime, which this
      package does not provide.
    '';
    homepage = "https://github.com/Genetic-Pottery/warlock";
    changelog = "https://github.com/Genetic-Pottery/warlock/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ asinglesprinkle ];
    mainProgram = "warlock";
  };
})
