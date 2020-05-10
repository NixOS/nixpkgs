{ buildDhallPackage, fetchFromGitHub, lib }:

# This function is used by `dhall-to-nixpkgs` when given a GitHub repository
lib.makeOverridable
  ( { # Arguments passed through to `buildDhallPackage`
      name
    , dependencies ? []
    , source ? false

    , # The directory containing the Dhall files, if other than the root of the
      # repository
      directory ? ""
    , # The file to import, relative to the above directory
      file ? "package.dhall"

      # Arguments passed through to `fetchFromGitHub`
    , owner
    , repo
    , rev
      # Extra arguments passed through to `fetchFromGitHub`, such as the hash
      # or `fetchSubmodules`
    , ...
    }@args:

    buildDhallPackage {
      inherit name dependencies source;

      code =
        let
          src = fetchFromGitHub ({
            name = "${name}-source";

            inherit owner repo rev;
          } // removeAttrs args [
            "name"
            "dependencies"
            "source"
            "directory"
            "file"
            "owner"
            "repo"
            "rev"
          ]);

          prefix = lib.optionalString (directory != "") "${directory}/";

        in
          "${src}/${prefix}${file}";
    }
  )
