{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "timescaledb-parallel-copy";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-parallel-copy";
    tag = "v${version}";
    hash = "sha256-vd+2KpURyVhcVf2ESHcyZLJCw+z+WbnTJX9Uy4ZAPoE=";
  };

  vendorHash = "sha256-MRso2uihMUc+rLwljwZZR1+1cXADCNg+JUpRcRU918g=";

  checkFlags =
    let
      # need Docker daemon
      skippedTests = [
        "TestWriteDataToCSV"
        "TestErrorAtRow"
        "TestErrorAtRowWithHeader"
        "TestWriteReportProgress"
        "TestFailedBatchHandler"
        "TestFailedBatchHandlerFailure"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "-version";

  meta = {
    description = "Bulk, parallel insert of CSV records into PostgreSQL";
    mainProgram = "timescaledb-parallel-copy";
    homepage = "https://github.com/timescale/timescaledb-parallel-copy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
