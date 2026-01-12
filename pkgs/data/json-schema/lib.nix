{
  lib,
  json-schema-catalog-rs,
  runCommand,
  jq,
}:
let

  /**
    A somewhat opinionated method for constructing a JSON Schema Catalog from files in a Nix store.

    The input is a slightly simpler format:

    ```nix
    {
      name = "my-catalog"; # derivation name, default displayName
      displayName = "My Catalog"; # optional
      groups = {
        "Group One" = {
          "https://example.com/schemas/one-v1.json" = pkgs.fetchurl { ... };
          "https://example.com/schemas/one-v2.json" = pkgs.fetchurl { ... };
          "https://example.com/schemas/one-common.json" = pkgs.fetchurl { ... };
        };
        "Group Two" = {
          "https://example.com/schemas/two-v1.json" = ./two-v1.json; # Files can be local
        };
      };
    }
    ```
  */
  newCatalog =
    {
      name,
      displayName ? name,
      groups,
      version ? null,
      extraDescription ? null,
      meta ? { },
    }:
    let
      # lazyDerivation tidies up the package attributes
      package = lib.lazyDerivation {
        derivation = drv;
        passthru = {
          name = "catalog-${name}";
          internals = drv;
        }
        // lib.optionalAttrs (version != null) {
          inherit version;
        };
        meta = {
          description = "JSON Schema Catalog for ${displayName}";
          longDescription =
            let
              licenses = lib.toList meta.license;
              show = license: license.fullName or license;
              theLicensesApply =
                if lib.length licenses == 1 then
                  "The package license, ${show (lib.head licenses)}, applies"
                else
                  "The package licenses, ${lib.concatMapStringsSep " / " show licenses}, apply";
            in
            ''
              A JSON Schema Catalog is a mapping from URIs to JSON Schema documents.
              It enables offline use, e.g. in build processes, and therefore it improves performance, robustness and safety.
              ${lib.optionalString (extraDescription != null) "\n${extraDescription}\n"}
              ${theLicensesApply} to the schemas in this catalog. The catalog file itself is licensed under the terms of the Nix expression that governs it, e.g. MIT in the case of Nixpkgs.
            '';
        }
        // meta;
      };

      drvArgs = {
        pname = name;
        catalogJson = builtins.toJSON {
          name = displayName;
          groups = lib.mapAttrsToList (name: group: {
            inherit name;
            # TODO dedup the longest common prefix by putting it in baseLocation
            baseLocation = "/";
            schemas = lib.mapAttrsToList (id: location: {
              inherit id;
              inherit location;
            }) group;
          }) groups;
        };
        passAsFile = [ "catalogJson" ];
        passthru = {
          inherit groups;
        };
        nativeBuildInputs = [
          jq
          json-schema-catalog-rs
        ];
      }
      // lib.optionalAttrs (version != null) {
        inherit version;
      };

      drv = runCommand "${package.name}${lib.optionalString (version != null) "-${version}"}" drvArgs ''
        out_dir="$out/share/json-schema-catalogs"
        out_file="$out_dir/$name.json"

        mkdir -p "$out_dir"

        # Write the catalog JSON. `jq` formats it nicely.
        jq . <"$catalogJsonPath" >"$out_file"

        json-schema-catalog check "$out_file"
      '';
    in
    package;
in
{
  lib =
    # Exported as part of `pkgs.jsonSchemaCatalogs`
    {
      inherit newCatalog;
    };
}
