{ buildDhallPackage, lib }:

# This is a minor variation on `buildDhallPackage` that splits the `code`
# argument into `src` and `file` in such a way that you can easily override
# the `file`
#
# This function is used by `dhall-to-nixpkgs` when given a directory
lib.makeOverridable
  ( { # Arguments passed through to `buildDhallPackage`
      name
    , dependencies ? []
    , source ? false

    , src
    , # The file to import, relative to the root directory
      file ? "package.dhall"
    }:

    buildDhallPackage {
      inherit name dependencies source;

      code = "${src}/${file}";
    }
  )

