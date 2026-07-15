{
  lib,
  callPackage,
  newScope,
}:
let
  toPackageName = name: version: "${name}_${lib.replaceStrings [ "." ] [ "_" ] version}";
in
lib.makeScope newScope (
  self:
  let
    # Not public, so do not expose to the package set
    buildUniversePackage = self.callPackage ./build-universe-package.nix { typstPackages = self; };

    # Creates a versioned package out of a name, version, and packageSpec
    makeVersionedPackage = pname: version: packageSpec: {
      name = toPackageName pname version;

      value = buildUniversePackage {
        homepage = packageSpec.homepage or null;
        inherit pname version;
        inherit (packageSpec)
          hash
          description
          license
          typstDeps
          ;
      };
    };

    # Create a derivation for each package. This is in the format of
    # typstPackages.${package}_version
    versionedPackages = lib.pipe (lib.importTOML ./typst-packages-from-universe.toml) [
      # 1. Create a list of versioned packages
      # Only recurse 2 levels deep because the leaf attrs are the pkgspec attrs
      (lib.mapAttrsToListRecursiveCond (path: _: (lib.length path) < 2) (
        path:
        let
          # Path is always [ path version ]
          pname = lib.head path;
          version = lib.last path;
        in
        makeVersionedPackage pname version
      ))
      # 2. Transform the list into a flat attrset
      lib.listToAttrs
    ];

    # Take two version strings and return the newer one
    selectNewerVersion = v1: v2: if lib.versionOlder v1 v2 then v2 else v1;

    # Select the latest version of each package to represent the
    # unversioned derivation in the format of:
    # typstPackages.${package}
    latestPackages = lib.pipe (lib.importTOML ./typst-packages-from-universe.toml) [
      # Take in the attrset of each package and all its versions
      # Compare each version and find the latest one.
      # Then select it from the versioned package set
      (lib.mapAttrs (
        pname: versions:
        let
          latestVersion = lib.foldl' selectNewerVersion "0.0.0" (lib.attrNames versions);
        in
        versionedPackages.${toPackageName pname latestVersion}
      ))
    ];
  in
  versionedPackages // latestPackages
)
