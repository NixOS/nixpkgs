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
  version = "0.1.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pablospe";
    repo = "worktrunk-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LGxTzXF/AWNWajH8gygbSQVpIidbArUZRaokefeD7es=";
  };

  cargoHash = "sha256-iClMQtyDH6SPJSaHXzOsme4uAJCoLQA9QF8EUu/FQDM=";

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
