{ lib, victoriametrics }:

# This package is build out of the victoriametrics package.
# so no separate update prs are needed for vmagent
# nixpkgs-update: no auto update
lib.addMetaAttrs { mainProgram = "vmagent"; } (
  victoriametrics.override {
    withServer = false;
    withVmAlert = false;
    withVmAuth = false;
    withBackupTools = false;
    withVmctl = false;
    withVmAgent = true;
  }
)
