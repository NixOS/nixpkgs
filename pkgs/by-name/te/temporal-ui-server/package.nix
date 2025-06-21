{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

let
  pname = "temporal-ui-server";
  version = "2.37.3";

in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "ui-server";
    tag = "v${version}";
    hash = "sha256-FsW+5FIe7ouKreLh0gdb/s9ChaOkByWRHXjiWts4Gf0=";
  };

  vendorHash = "sha256-Skv+n0Da0Wgi8yjiHDcZsYwIWK4pbzdgsnrpurXudJ0=";

  meta = {
    homepage = "https://github.com/temporalio/ui-server";
    description = "Golang Server for Temporal Web UI";
    longDescription = ''
      The Temporal Web UI provides users with Workflow Execution state and metadata
      for debugging purposes. This golang server provides a binary that you can run
      to serve the compiled temporal ui (https://github.com/temporalio/ui).
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ breakds ];
  };
}
