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
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BJRvz3rFLaOCNhOsEo0rSOgB9BCJ2LMB9XEw8RBWXXs=";
  };

  cargoHash = "sha256-VtSRC4lyjMo2O9dNbVllcDEx08zQWJMQmQ/2bNMup6U=";

  nativeBuildInputs = [ installShellFiles ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AppKit";

  checkFlags = [
    "--skip=help"
    "--skip=help_short"
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Executes commands in response to file modifications";
    homepage = "https://watchexec.github.io/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      michalrus
      prince213
    ];
    mainProgram = "watchexec";
  };
})
