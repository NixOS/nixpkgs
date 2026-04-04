{ lib, victorialogs }:

# This package is build out of the victorialogs package.
# so no separate update prs are needed for vlagent
# nixpkgs-update: no auto update
lib.addMetaAttrs { mainProgram = "vlagent"; } (
  victorialogs.override {
    withServer = false;
    withVlAgent = true;
  }
)
