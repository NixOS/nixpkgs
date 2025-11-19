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
  lib.foldlAttrs (
    packageSet: pname: versionSet:
    packageSet
    // (lib.foldlAttrs (
      subPackageSet: version: packageSpec:
      subPackageSet
      // {
        ${toPackageName pname version} = self.callPackage ./build-universe-package.nix {
          inherit (packageSpec)
            hash
            description
            license
            typstDeps
            homepage
            ;
        };
      }
    ) { } versionSet)
    // {
      ${pname} = self.${toPackageName pname (lib.last (lib.attrNames versionSet))};
    }
  ) { } (lib.importTOML ./typst-packages-from-universe.toml)
)
