/* Create a Python executable that knows about additional packages. */

{ stdenv, python, buildEnv, makeWrapper
, extraLibs ? []
, extraOutputsToInstall ? []
, postBuild ? ""
, ignoreCollisions ? false }:

with stdenv.lib;

let
  recursivePthLoader = import ../../python-modules/recursive-pth-loader/default.nix {
    inherit stdenv python;
  };
  inputs = extraLibs ++ [ python recursivePthLoader ];
  # https://git.io/vFV56
  pickOutputs = drv:
    if (drv.outputUnspecified or false) && (drv.meta.outputsToInstall or null) != null
    then (map (out: getOutput out drv) drv.meta.outputsToInstall)
    else [ drv ]
    ++ filter isNull (map (out: getOutput out drv) extraOutputsToInstall);
  closePropagation' = drvs:
    map (drv: drv // { outputUnspecified = true; }) (closePropagation drvs);
  paths = concatLists (map pickOutputs (closePropagation' inputs));
  self = buildEnv {
    inherit ignoreCollisions extraOutputsToInstall paths;
    inherit (python) meta;

    name = "${python.name}-env";
    buildInputs = [ makeWrapper ];

    postBuild = ''
      if [ -L $out/bin ]; then
        unlink $out/bin
      fi

      mkdir -p $out/bin

      for path in ${concatStringsSep " " paths}; do
        if [ -d $path/bin ]; then
          cd $path/bin
          for x in *; do
            if [ -f $x ] && [ -x $x ]; then
              rm -f $out/bin/$x
              makeWrapper $path/bin/$x $out/bin/$x \
                --set PYTHONHOME $out \
                --set PYTHONNOUSERSITE true
            fi
          done
        fi
      done

      ${postBuild}
    '';

    passthru = python.passthru // {
      inherit python;
      interpreter = "${self}/bin/${python.executable}";
      env = stdenv.mkDerivation {
        name = "interactive-${python.name}-environment";
        nativeBuildInputs = [ self ];

        buildCommand = ''
	  cat >&2 << EOF

*** Python 'env' attributes are intended for interactive nix-shell sessions, not for building! ***

EOF
          exit 1
        '';
      };
    };
  };
in

self
