{ buildDhallPackage, lib }:

# This is a minor variation on `buildDhallPackage` that splits the `code`
# argument into `src` and `file` in such a way that you can easily override
# the `file`
#
# This function is used by `dhall-to-nixpkgs` when given a directory
lib.makePackageOverridable (
  {
    # Arguments passed through to `buildDhallPackage`
    name,
    dependencies ? [ ],
    source ? false,

    src,
    # The file to import, relative to the root directory
    file ? "package.dhall",
    # Set to `true` to generate documentation for the package
    document ? false,
  }:

  buildDhallPackage (
    {
      inherit name dependencies source;

      code = "${src}/${file}";

    }
    // lib.optionalAttrs document { documentationRoot = "${src}"; }
  )
)
