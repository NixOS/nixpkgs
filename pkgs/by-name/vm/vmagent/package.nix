{ lib, victoriametrics }:
lib.addMetaAttrs { mainProgram = "vmagent"; } (
  victoriametrics.override {
    withServer = false;
    withVictoriaLogs = false;
    withVmAlert = false;
    withVmAuth = false;
    withBackupTools = false;
    withVmctl = false;
    withVmAgent = true;
  }
)
