{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  versionCheckHook,
  installShellFiles,
  nix-update-script,
  pkg-config,
  libgit2,
  neovim,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "teamtype";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "teamtype";
    repo = "teamtype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FsT1ako/3EIPynWuBqCSiwaZtMnsd7ypJnrh+4EDRwM=";
  };

  cargoHash = "sha256-gphTpVKbmfYJSUasOCtNgyMKI9JU/if8KcH7Lu3Svjs=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libgit2
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

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

  nativeCheckInputs = [
    neovim
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    substituteInPlace .cargo/config.toml \
      --replace-fail 'target/debug/teamtype' 'target/${stdenv.hostPlatform.rust.rustcTarget}/release/teamtype'
  '';

  # watcher tests use FSEvents which hangs in the macOS sandbox
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=watcher::"
  ];

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
      alerque
      ethancedwards8
      prince213
    ];
  };
})
