{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "timescaledb-parallel-copy";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-parallel-copy";
    tag = "v${finalAttrs.version}";
    name = "timescaledb-parallel-copy-v0.12.0-source";
    hash = "sha256-ICy1Z3ePydHN7yTNwL+Zj9tlK2L/w1xa1mPFTZzlmFY=";
  };

  vendorHash = "sha256-EB/9U2RROC9IFDkVXe5fPm+pOQUKlse262OQdhZrtn8=";

  #Upstream forgot to bump the hardcoded version string in 0.12.0.
  #This hack can be removed once they update the version in cmd/timescaledb-parallel-copy/main.go.
  postPatch = ''
    substituteInPlace cmd/timescaledb-parallel-copy/main.go \
      --replace-fail 'version    = "v0.11.0"' 'version    = "v${finalAttrs.version}"'
  '';

  checkFlags =
    let
      # need Docker daemon
      skippedTests = [
        "TestWriteDataToCSV"
        "TestErrorAtRow"
        "TestWriteReportProgress"
        "TestFailedBatchHandler"
        "TestTransaction"
        "TestAtomicity"
        "TestBatchConflict"
      ];
    in
    [ "-skip=^(${builtins.concatStringsSep "|" skippedTests})" ];

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
})
