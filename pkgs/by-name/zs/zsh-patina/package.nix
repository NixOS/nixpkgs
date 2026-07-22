{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zsh-patina";
  version = "1.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "michel-kraemer";
    repo = "zsh-patina";
    tag = finalAttrs.version;
    hash = "sha256-sPlIT3UHtq+5+bpfrSPPfVXTdmqjEq+6k9tPShhG7h0=";
  };

  cargoHash = "sha256-j2MwEwQhSCUCwANAxr0aZjJ9iS0cGzRRttfK8LONEpg=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    install -Dm644 LICENSE $out/share/licenses/zsh-patina/LICENSE
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zsh-patina --zsh <($out/bin/zsh-patina completion)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Zsh syntax highlighter";
    homepage = "https://github.com/michel-kraemer/zsh-patina";
    changelog = "https://github.com/michel-kraemer/zsh-patina/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lubsch ];
    platforms = lib.platforms.unix;
    mainProgram = "zsh-patina";
  };
})
