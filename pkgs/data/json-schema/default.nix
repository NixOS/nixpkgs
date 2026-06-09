{
  lib,
  newScope,
  json-schema-catalog-rs,
  jsonschema-cli,
}:
let
  inherit (lib) concatMapAttrs optionalAttrs;
  inherit (lib.strings) hasSuffix removeSuffix;

  jsonSchemaCatalogs = lib.makeScope newScope (
    self:
    {
      inherit ((self.callPackage ./lib.nix { }).lib) newCatalog;
      tests = self.callPackage ./tests.nix { };
    }
    // concatMapAttrs (
      k: v:
      optionalAttrs (v == "regular" && hasSuffix ".nix" k) {
        ${removeSuffix ".nix" k} = self.callPackage (./catalogs + "/${k}") { };
      }
    ) (builtins.readDir ./catalogs)
  );
in
{
  # Exported to `pkgs`
  jsonSchemaCatalogs = lib.recurseIntoAttrs jsonSchemaCatalogs;
}
