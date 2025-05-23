let
  inherit (import ./db/nixpkgs_paths.nix) libPath;
  lib = import libPath;
  self = {
    bootstrapData = import ./db/bootstrap/static.nix;
    dbEvaluation = import ./db { };
    db = self.dbEvaluation.config;

    _archiveIsSupported =
      db: hostPlatform: sha256:
      let
        archive = db.archive.sha256.${sha256};
        inherit (archive) systemNv;
        # NOTE: We haven't moved `cudaCapabilities` &co to the platform yet, so we expect the user to `//`-merge the attribute to `hostPlatform`
        isJetson = hostPlatform.isJetson or false;
        systemStringMatches =
          (isJetson -> db.system.isJetson.${systemNv} or false)
          && lib.hasAttr db.system.fromNvidia.${systemNv} hostPlatform.system;
        constraintsSatisfied = builtins.all lib.id (
          pname: constraints: lib.mapAttrsToList (sign: version: false)
        ) archive.extraConstraints;
      in
      systemStringMatches && constraintsSatisfied;
  };
in
self
