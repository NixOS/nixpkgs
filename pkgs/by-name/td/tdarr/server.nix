{ mkTdarr, ccextractor }:

mkTdarr {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-f+yoe72zIG9MfmNccMfC9r8GNrYG9JNawD+LrxJI1wM=";
    linux_arm64 = "sha256-dCOzQAoiw84ZoHmKKQN8SMI4vS5LTVGkVetEu3g9cvc=";
    darwin_arm64 = "sha256-xKscszjhPL0KtEHb9rGUPhHV9ZTtPB5KwgYIlH0Evow=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
