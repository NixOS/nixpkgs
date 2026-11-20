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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "hyperb1iss";
    repo = "unifly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qIg97XAO1RY5byWd5wL++tJgtBPdS3F0Zv2u9CwivJs=";
  };

  nativeBuildInputs = [
    pkg-config
    llvmPackages.bintools
    installShellFiles
  ];

  buildInputs = [ dbus ];

  cargoHash = "sha256-thwBO1FgTG+5DH/1xdnYbiBpnf8qrgswCTm4AdY2dzg=";

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
