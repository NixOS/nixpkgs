{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "temporal-ui-server";
  version = "2.58.1";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "ui-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yK81GQA5ay6FKtMTmKxksEvF6y0Hpe8xzW+Cura1hlI=";
  };

  vendorHash = "sha256-h9hxEaINz5sEVpdYEKpTrgOfPFn+h87FpvBh76Y8R+I=";

  postInstall = ''
    mv $out/bin/server $out/bin/temporal-ui-server
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/temporalio/ui-server/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/temporalio/ui-server";
    description = "Golang Server for Temporal Web UI";
    longDescription = ''
      The Temporal Web UI provides users with Workflow Execution state and metadata
      for debugging purposes. This golang server provides a binary that you can run
      to serve the compiled temporal ui (https://github.com/temporalio/ui).
    '';
    mainProgram = "temporal-ui-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      breakds
      jlesquembre
    ];
  };
})
