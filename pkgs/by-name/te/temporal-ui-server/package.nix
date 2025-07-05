{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "temporal-ui-server";
  version = "2.38.3";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "ui-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y8zDrnSX9cZROvY+0rKmKK+9CPOk24ArezEbzey5ly0=";
  };

  vendorHash = "sha256-ySbVxJrW8G3VhFrtmomWGk70wOrXnrXsqaPivhioJjo=";

  postInstall = ''
    mv $out/bin/server $out/bin/temporal-ui-server
  '';

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
