{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "whosthere";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "ramonvermeulen";
    repo = "whosthere";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FgjsmUg4oEF+WVBhZXIE0MzpBr+s9sXuXIFxqHKD8U8=";
  };

  vendorHash = "sha256-mQ17BCJGc4LQOUdyWGlWoSJPbqwg55vRGfEbrcDllG4=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-X"
    "main.versionStr=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd whosthere \
      --bash <("$out/bin/whosthere" completion bash) \
      --fish <("$out/bin/whosthere" completion fish) \
      --zsh <("$out/bin/whosthere" completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local Area Network discovery tool";
    longDescription = ''
      Local Area Network discovery tool with a modern Terminal User Interface
      (TUI) written in Go. Discover, explore, and understand your LAN in an
      intuitive way. Knock Knock.. who's there?
    '';
    homepage = "https://github.com/ramonvermeulen/whosthere";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
    mainProgram = "whosthere";
  };
})
