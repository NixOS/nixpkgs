{ stdenv, python, buildEnv, makeWrapper
, extraLibs ? []
, postBuild ? ""
, ignoreCollisions ? false }:

# Create a python executable that knows about additional packages.
let
  recursivePthLoader = import ../../python-modules/recursive-pth-loader/default.nix { stdenv = stdenv; python = python; };
  env = (
  let
    paths = stdenv.lib.closePropagation (extraLibs ++ [ python recursivePthLoader ] ) ;
  in buildEnv {
    name = "${python.name}-env";

    inherit paths;
    inherit ignoreCollisions;

    postBuild = ''
      . "${makeWrapper}/nix-support/setup-hook"

      if [ -L "$out/bin" ]; then
          unlink "$out/bin"
      fi
      mkdir -p "$out/bin"

      # Generate new wrapper scripts for the all the executables found in our
      # dependencies.  These wrapper scripts force PYTHONHOME to point to the
      # new package we are creating.
      #
      # This ends up generating wrappers for both the original executables and
      # the pre-existing wrapper scripts.  Only the wrappers for the original
      # executables will be used, so it doesn't hurt anything --- it's just a
      # little distressing.
      #
      # The "wrapped wrappers" will not function correctly, since they might
      # immediately set PYTHONHOME to be something else.
      srcstores=(${stdenv.lib.concatStringsSep " " paths})
      for srcstore in "''${srcstores[@]}"; do
        if [[ -d "$srcstore"/bin ]]; then
          find "$srcstore"/bin -type f -executable -print0 \
          | while IFS= read -d "" srcfile; do
            dstfile="$out/bin/$(basename $srcfile)"
            rm -f $dstfile
            makeWrapper "$srcfile" "$dstfile" --set PYTHONHOME "$out"
          done
        fi
      done

    '' + postBuild;

    passthru.env = stdenv.mkDerivation {
      name = "interactive-${python.name}-environment";
      nativeBuildInputs = [ env ];

      buildCommand = ''
        echo >&2 ""
        echo >&2 "*** Python 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
        echo >&2 ""
        exit 1
      '';
    };
  }) // {
    inherit python;
    inherit (python) meta;
  };
in env
