{ buildAstalModule, nix-update-script }:
(buildAstalModule {
  name = "io";
  sourceRoot = "lib/astal/io";
  meta = {
    description = "Astal core library";
    longDescription = ''
      Astal is a collection of building blocks for creating custom desktop shells
    '';
    mainProgram = "astal";
  };
}).overrideAttrs
  {
    # add an update script only in one place,
    # so r-ryantm won't run it multiple times
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  }
