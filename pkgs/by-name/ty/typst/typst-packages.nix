{
  lib,
  callPackage,
}:

lib.makeExtensible (
  final:
  lib.recurseIntoAttrs (
    lib.mapAttrs (
      name: packageSpec:
      callPackage (
        {
          lib,
          buildTypstPackage,
          fetchurl,
        }:
        buildTypstPackage {
          inherit (packageSpec) pname version;

          src = fetchurl {
            inherit (packageSpec) url hash;
          };

          sourceRoot = ".";

          typstDeps = builtins.filter (x: x != null) (
            lib.map (d: (lib.attrsets.attrByPath [ d ] null final)) packageSpec.typstDeps
          );

          meta = {
            inherit (packageSpec) description;
            maintainers = with lib.maintainers; [ cherrypiejam ];
            license = lib.map (lib.flip lib.getAttr lib.licensesSpdx) packageSpec.license;
          } // (if packageSpec ? "homepage" then { inherit (packageSpec) homepage; } else { });
        }
      ) { }
    ) (lib.importTOML ./typst-packages-from-universe.toml)
  )
)
