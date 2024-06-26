{ dhall-nixpkgs, lib, stdenv }:

# This function calls `dhall-to-nixpkgs directory --fixed-output-derivations`
# within a Nix derivation.
#
# This is possible because
# `dhall-to-nixpkgs directory --fixed-output-derivations` will turn remote
# Dhall imports protected with Dhall integrity checksinto fixed-output
# derivations (with the `buildDhallUrl` function), so no unrestricted network
# access is necessary.
lib.makePackageOverridable
  ( { src
    , # The file to import, relative to the root directory
      file ? "package.dhall"
    , # Set to `true` to generate documentation for the package
      document ? false
    }:
    stdenv.mkDerivation {
      name = "dhall-directory-package.nix";

      buildCommand = ''
        dhall-to-nixpkgs directory --fixed-output-derivations --file "${file}" "${src}" ${lib.optionalString document "--document"} > $out
      '';

      nativeBuildInputs = [ dhall-nixpkgs ];
    }
  )
