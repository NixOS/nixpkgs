{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "temporal-ui-server";
  version = "2.40.1";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "ui-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2O2FGZTgZwEDY3RDtlzKgd9yzCwUQBj5paqX7R8Yupc=";
  };

  vendorHash = "sha256-KOvueOK/nmBFE4hNeacgFtv/FzhS6UJzNpXIby8J++E=";

  postInstall = ''
    mv $out/bin/server $out/bin/temporal-ui-server
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
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
