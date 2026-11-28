{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watchexec";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IyzJpf7VEUKy9qGgwaDRQJr2E8J1hw1RifuW9/UUCWM=";
  };

  cargoHash = "sha256-m3lDL9HfXpIYZLrjtrSa8FWgVT3eXDAkBkMknHqwR4I=";

  nativeBuildInputs = [ installShellFiles ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework"
      "AppKit"
    ];
  };

  checkFlags = [
    # v2.8.0: these fail in the build sandbox, but seem to work fine outside it
    "--skip=args::filtering::tests::relative_watched_paths_resolve_against_the_workdir"
    "--skip=dirs::tests::discovers_the_origin_of_a_watched_path"
    "--skip=dirs::tests::discovers_the_same_origin_from_anywhere_in_the_project"
  ];

  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --cmd watchexec \
      --bash completions/bash \
      --fish completions/fish \
      --zsh completions/zsh
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(.+)"
    ];
  };

  meta = {
    description = "Executes commands in response to file modifications";
    homepage = "https://watchexec.github.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      michalrus
      prince213
    ];
    mainProgram = "watchexec";
  };
})
