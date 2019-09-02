{ stdenv, perl, buildEnv, makeWrapper
, extraLibs ? []
, extraOutputsToInstall ? []
, postBuild ? ""
, ignoreCollisions ? false
, lib
, requiredPerlModules
, makeWrapperArgs ? []
}:

# Create a perl executable that knows about additional packages.
let
  env = let
    paths = requiredPerlModules (extraLibs ++ [ perl ] );
  in buildEnv {
    name = "${perl.name}-env";

    inherit paths;
    inherit ignoreCollisions;
    extraOutputsToInstall = [ "out" ] ++ extraOutputsToInstall;

    # we create wrapper for the binaries in the different packages
    postBuild = ''

      . "${makeWrapper}/nix-support/setup-hook"

      if [ -L "$out/bin" ]; then
          unlink "$out/bin"
      fi
      mkdir -p "$out/bin"

      # take every binary from perl packages and put them into the env
      for path in ${stdenv.lib.concatStringsSep " " paths}; do
        if [ -d "$path/bin" ]; then
          cd "$path/bin"
          for prg in *; do
            if [ -f "$prg" ]; then
              rm -f "$out/bin/$prg"
              if [ -x "$prg" ]; then
                makeWrapper "$path/bin/$prg" "$out/bin/$prg" --set PERL5LIB "$out/${perl.libPrefix}"
              fi
            fi
          done
        fi
      done
    '' + postBuild;

    meta = perl.meta // { outputsToInstall = ["out"]; }; # remove "man" from meta.outputsToInstall. pkgs.buildEnv produces no "man", it puts everything to "out"

    passthru = perl.passthru // {
      interpreter = "${env}/bin/perl";
      inherit perl;
    };
  };
in env
