{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "teamtype";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "teamtype";
    repo = "teamtype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-74MufpLTACkPevzOyaXw2Rr7S7VvaFEYHEyTQYwKVT8=";
  };

  sourceRoot = "${finalAttrs.src.name}/daemon";

  cargoHash = "sha256-OIOffnCC9PlT/SXPOuTnKx3feZnkHP+jzbQIJWX0tzk=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage \
      target/manpages/teamtype.1 \
      target/manpages/teamtype-client.1 \
      target/manpages/teamtype-join.1 \
      target/manpages/teamtype-share.1

    installShellCompletion --bash target/completions/teamtype.bash
    installShellCompletion --zsh target/completions/_teamtype
    installShellCompletion --fish target/completions/teamtype.fish
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time co-editing of local text files";
    homepage = "https://teamtype.github.io/teamtype/";
    downloadPage = "https://github.com/teamtype/teamtype";
    changelog = "https://github.com/teamtype/teamtype/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    mainProgram = "teamtype";
    teams = [ lib.teams.ngi ];
    maintainers = with lib.maintainers; [
      prince213
      ethancedwards8
    ];
  };
})
