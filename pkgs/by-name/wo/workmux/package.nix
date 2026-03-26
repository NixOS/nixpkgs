{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "workmux";
  version = "0.1.138";

  src = fetchFromGitHub {
    owner = "raine";
    repo = "workmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FOKbfRmFTvK2exQfy+5DHHdlCwtsZuueZrcPNvHSncI=";
  };

  cargoHash = "sha256-Mil5l/VZLTQmhDGEXCTFNH1L4mGjt1wOLV11h2mn8pY=";

  nativeBuildInputs = [
    installShellFiles
    git
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME=$TMPDIR
    installShellCompletion --cmd workmux \
      --bash <($out/bin/workmux completions bash) \
      --fish <($out/bin/workmux completions fish) \
      --zsh <($out/bin/workmux completions zsh)
  '';

  meta = {
    description = "Orchestrate git worktrees and terminal multiplexer windows as isolated development environments";
    homepage = "https://github.com/raine/workmux";
    changelog = "https://github.com/raine/workmux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "workmux";
  };
})
