{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  llvmPackages,
  installShellFiles,
  dbus,
  versionCheckHook,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "unifly";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "hyperb1iss";
    repo = "unifly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vjAVnXNmkBltLOEvY4MXIbxzdg7aGbkhbGsL5+pH9wQ=";
  };

  nativeBuildInputs = [
    pkg-config
    llvmPackages.bintools
    installShellFiles
  ];

  buildInputs = [ dbus ];

  cargoHash = "sha256-PkLS8oyK9Pmpq3jWZiLO+bsS4zVUyd4jZFxaMo+AWPI=";

  doCheck = false;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd unifly \
      --bash <($out/bin/unifly completions bash) \
      --fish <($out/bin/unifly completions fish) \
      --zsh <($out/bin/unifly completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Elegant UniFi network management CLI & TUI - for humans and agents";
    homepage = "https://hyperb1iss.github.io/unifly";
    changelog = "https://github.com/hyperb1iss/unifly/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ britter ];
    mainProgram = "unifly";
  };
})
