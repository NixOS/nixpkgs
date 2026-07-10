{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "temporal-ui-server";
  version = "2.49.1";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "ui-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cCYBMNkQZBdy1OpofI0THT9qDtYdsfI/rl3MWi0K1CU=";
  };

  vendorHash = "sha256-nw4OHa13kRvdR6IFop5eZiB+5+cJCry4sgTnercRq9s=";

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
    maintainers = with lib.maintainers; [ breakds ];
  };
})
