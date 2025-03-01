{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "xo";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "xo";
    repo = "xo";
    tag = "v${version}";
    hash = "sha256-cmSY+Et2rE+hLZ1+d2Vvwp+CX0hfLz08QKivQQd7SIQ=";
  };

  vendorHash = "sha256-aTjLoP7u2mMF1Ns/Wb9RR0xAqQCZJjjb5UzY2de6yBU=";

  ldflags = [
    "-X main.version=v${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd xo \
        --bash <(${emulator} $out/bin/xo completion bash) \
        --fish <(${emulator} $out/bin/xo completion fish) \
        --zsh <(${emulator} $out/bin/xo completion zsh)
    ''
  );

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool to generate idiomatic Go code for SQL databases supporting PostgreSQL, MySQL, SQLite, Oracle, and Microsoft SQL Server";
    homepage = "https://github.com/xo/xo";
    changelog = "https://github.com/xo/xo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "xo";
  };
}
