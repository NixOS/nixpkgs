{
  lib,
  callPackage,
}:

let
  toPackageName = name: version: "${name}_${lib.replaceStrings [ "." ] [ "_" ] version}";
in
lib.makeExtensible (
  final:
  lib.recurseIntoAttrs (
    lib.foldlAttrs (
      packageSet: pname: versionSet:
      packageSet
      // (lib.foldlAttrs (
        subPackageSet: version: packageSpec:
        subPackageSet
        // {
          ${toPackageName pname version} = callPackage (
            {
              lib,
              buildTypstPackage,
              fetchzip,
            }:
            buildTypstPackage (finalAttrs: {
              inherit pname version;

              src = fetchzip {
                inherit (packageSpec) hash;
                url = "https://packages.typst.org/preview/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
                stripRoot = false;
              };

              typstDeps = builtins.filter (x: x != null) (
                lib.map (d: (lib.attrsets.attrByPath [ d ] null final)) packageSpec.typstDeps
              );

              meta = {
                inherit (packageSpec) description;
                maintainers = with lib.maintainers; [ cherrypiejam ];
                license = lib.map (lib.flip lib.getAttr lib.licensesSpdx) packageSpec.license;
              }
              // (if packageSpec ? "homepage" then { inherit (packageSpec) homepage; } else { });
            })
          ) { };
        }
      ) { } versionSet)
      // {
        ${pname} = final.${toPackageName pname (lib.last (lib.attrNames versionSet))};
      }
    ) { } (lib.importTOML ./typst-packages-from-universe.toml)
  )
)
