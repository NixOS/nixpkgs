{
  lib,
  fetchFromGitHub,
  gitMinimal,
  makeWrapper,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worktrunk-sync";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pablospe";
    repo = "worktrunk-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ua9JPlXgO3dg3MkRvM4znwMp36fE1E/EFgZjkSKSrqQ=";
  };

  cargoHash = "sha256-RHocExKv2cbpVhD21xU1QxAnkW2WMaQIS0kG9h4pfiM=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ gitMinimal ];

  postInstall = ''
    wrapProgram $out/bin/wt-sync \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rebase stacked worktree branches in dependency order";
    homepage = "https://github.com/pablospe/worktrunk-sync";
    changelog = "https://github.com/pablospe/worktrunk-sync/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ steveej ];
    mainProgram = "wt-sync";
  };
})
