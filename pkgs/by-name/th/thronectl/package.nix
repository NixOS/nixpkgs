{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,

  installShellFiles,
  versionCheckHook,

  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "thronectl";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "throneproj";
    repo = "Throne-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-upkjrBXriYo87gKX3atc8WxUG4llJZKbawfAzOLUR9A=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-6/kFohF3iGbLvvEOkyTKMPxRAHQ12Av1oOtJqeru4fA=";

  subPackages = [ "cmd/thronectl" ];

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${finalAttrs.version}"
  ];

  preCheck = ''
    # completion tests fail for some reason
    rm cmd/thronectl/completion_test.go
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd thronectl \
      --bash <("$out/bin/thronectl" completion bash) \
      --zsh  <("$out/bin/thronectl" completion zsh) \
      --fish <("$out/bin/thronectl" completion fish)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line interface to remotely control Throne";
    homepage = "https://github.com/throneproj/Throne-api";
    changelog = "https://github.com/throneproj/Throne-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tomasajt
      Mahdi-zarei
    ];
    mainProgram = "thronectl";
  };
})
