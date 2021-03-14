{ lib, stdenv, octave, buildEnv
, makeWrapper, texinfo
, octavePackages
, wrapOctave
, computeRequiredOctavePackages
, extraLibs ? []
, extraOutputsToInstall ? []
, postBuild ? ""
, ignoreCollisions ? false
}:

# Create an octave executable that knows about additional packages
let
  packages = computeRequiredOctavePackages extraLibs;

in buildEnv {
  name = "${octave.name}-env";
  paths = extraLibs ++ [ octave ];

  inherit ignoreCollisions;
  extraOutputsToInstall = [ "out" ] ++ extraOutputsToInstall;

  buildInputs = [ makeWrapper texinfo wrapOctave ];

  # During "build" we must first unlink the /share symlink to octave's /share
  # Then, we can re-symlink the all of octave/share, except for /share/octave
  # in env/share/octave, re-symlink everything from octave/share/octave and then
  # perform the pkg install.
  postBuild = ''
      . "${makeWrapper}/nix-support/setup-hook"
      # The `makeWrapper` used here is the one defined in
      # ${makeWrapper}/nix-support/setup-hook

      if [ -L "$out/bin" ]; then
         unlink $out/bin
         mkdir -p "$out/bin"
         cd "${octave}/bin"
         for prg in *; do
             if [ -x $prg ]; then
                makeWrapper "${octave}/bin/$prg" "$out/bin/$prg" --set OCTAVE_SITE_INITFILE "$out/share/octave/site/m/startup/octaverc"
             fi
         done
         cd $out
      fi

      # Remove symlinks to the input tarballs, they aren't needed.
      rm $out/*.tar.gz

      createOctavePackagesPath $out ${octave}

      for path in ${lib.concatStringsSep " " packages}; do
          if [ -e $path/*.tar.gz ]; then
             $out/bin/octave-cli --eval "pkg local_list $out/.octave_packages; \
                                         pkg prefix $out/${octave.octPkgsPath} $out/${octave.octPkgsPath}; \
                                         pfx = pkg (\"prefix\"); \
                                         pkg install -nodeps -local $path/*.tar.gz"
          fi
      done

      # Re-write the octave-wide startup file (share/octave/site/m/startup/octaverc)
      # To point to the new local_list in $out
      addPkgLocalList $out ${octave}

      wrapOctavePrograms "${lib.concatStringsSep " " packages}"
     '' + postBuild;

  inherit (octave) meta;

  passthru = octave.passthru // {
    interpreter = "$out/bin/octave";
    inherit octave;
    env = stdenv.mkDerivation {
      name = "interactive-${octave.name}-environment";

      buildCommand = ''
        echo >&2 ""
        echo >&2 "*** octave 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
        echo >&2 ""
        exit 1
      '';
    };
  };
}
