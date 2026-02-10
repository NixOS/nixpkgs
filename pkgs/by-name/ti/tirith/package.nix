{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (final: {
  pname = "tirith";
  version = "0.1.9";
  src = fetchFromGitHub {
    owner = "sheeki03";
    repo = "tirith";
    tag = "v${final.version}";
    hash = "sha256-HrYpcVmHBNPB4I+Luq9EwZ003M5TU2FVHhP8CmRRi2I=";
  };

  cargoHash = "sha256-RxKK9jnIRsvj2fOVq1cv0B4SSb5EwvBk5eIUGC2H7dY=";

  cargoBuildFlags = [
    "-p"
    "tirith"
  ];

  checkFlags = [
    # requires a fully functional shell environment, generating init scripts needs a patch under nix to work at build time
    "--skip=init_bash_output"
    "--skip=init_zsh_output"
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tirith \
      --bash <("$out/bin/tirith" completions bash) \
      --zsh <("$out/bin/tirith" completions zsh) \
      --fish <("$out/bin/tirith" completions fish)
  '';

  meta = {
    description = "Shell security tool that guards against homograph URL attacks, pipe-to-shell exploits, and other command-line threats before they execute";
    homepage = "https://github.com/sheeki03/tirith";
    changelog = "https://github.com/sheeki03/tirith/blob/${final.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ toasteruwu ];
    platforms = lib.platforms.unix;
    mainProgram = "tirith";
  };
})
