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
  version = "0.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pablospe";
    repo = "worktrunk-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S9UWTRaQmYxpd0fj1btXXIxMze5hn85OhXyUVkAwKZw=";
  };

  cargoHash = "sha256-YH9VStvnhMsMSJK81l8tMoBvzTiWWTOtGxC8JVMCb0Q=";

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
