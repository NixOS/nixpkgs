{ lib, stdenv, buildEnv, makeBinaryWrapper

# manually pased
, python
, requiredPythonModules

# extra opts
, extraLibs ? []
, extraOutputsToInstall ? []
, postBuild ? ""
, ignoreCollisions ? false
, permitUserSite ? false
# Wrap executables with the given argument.
, makeWrapperArgs ? []
, }:

# Create a python executable that knows about additional packages.
let
  env = let
    paths = requiredPythonModules (extraLibs ++ [ python ] ) ;
    pythonPath = "${placeholder "out"}/${python.sitePackages}";
    pythonExecutable = "${placeholder "out"}/bin/${python.executable}";
  in buildEnv {
    name = "${python.name}-env";

    inherit paths;
    inherit ignoreCollisions;
    extraOutputsToInstall = [ "out" ] ++ extraOutputsToInstall;

    nativeBuildInputs = [ makeBinaryWrapper ];

    postBuild = ''
      if [ -L "$out/bin" ]; then
          unlink "$out/bin"
      fi
      mkdir -p "$out/bin"

      rm -f $out/bin/.*-wrapped

      for path in ${lib.concatStringsSep " " paths}; do
        if [ -d "$path/bin" ]; then
          cd "$path/bin"
          for prg in *; do
            if [ -f "$prg" ]; then
              rm -f "$out/bin/$prg"
              if [ -x "$prg" ]; then
                if [ -f ".$prg-wrapped" ]; then
                  echo "#!${pythonExecutable}" > "$out/bin/$prg"
                  sed -e '1d' -e '3d' ".$prg-wrapped" >> "$out/bin/$prg"
                  chmod +x "$out/bin/$prg"
                else
                  makeWrapper "$path/bin/$prg" "$out/bin/$prg" --argv0 "$out/bin/$prg" ${lib.optionalString (!permitUserSite) ''--set PYTHONNOUSERSITE "true"''} ${lib.concatStringsSep " " makeWrapperArgs}
                fi
              fi
            fi
          done
        fi
      done
    '' + postBuild;

    inherit (python) meta;

    passthru = python.passthru // {
      interpreter = "${env}/bin/${python.executable}";
      inherit python;
      env = stdenv.mkDerivation {
        name = "interactive-${python.name}-environment";
        nativeBuildInputs = [ env ];

        buildCommand = ''
          echo >&2 ""
          echo >&2 "*** Python 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
          echo >&2 ""
          exit 1
        '';
    };
    };
  };
in env
