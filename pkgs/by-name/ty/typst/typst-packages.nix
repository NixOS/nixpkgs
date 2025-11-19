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
  in
  lib.pipe (lib.importTOML ./typst-packages-from-universe.toml) [
    (lib.mapAttrsToListRecursive (
      path: packageSet:
      let
        # Path is always [ path version ]
        pname = lib.head path;
        version = lib.last path;
      in
      {
        name = toPackageName pname version;

        value = buildUniversePackage {
          inherit pname version;
          inherit (packageSpec)
            hash
            description
            license
            typstDeps
            homepage
            ;
        };
      }
    ))
    lib.listToAttrs
  ]
)
