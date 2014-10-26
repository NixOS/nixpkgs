{ stdenv, python, buildEnv, makeWrapper
, extraLibs ? []
, postBuild ? ""
, ignoreCollisions ? false }:

# Create a python executable that knows about additional packages.
let
  recursivePthLoader = import ../../python-modules/recursive-pth-loader/default.nix { stdenv = stdenv; python = python; };
in
(buildEnv {
  name = "${python.name}-env";
  paths = stdenv.lib.filter (x : x ? pythonPath) (stdenv.lib.closePropagation extraLibs) ++ [ python recursivePthLoader ];

  inherit ignoreCollisions;

  postBuild = ''
    . "${makeWrapper}/nix-support/setup-hook"

    if [ -L "$out/bin" ]; then
        unlink "$out/bin"
    fi
    mkdir -p "$out/bin"

    cd "${python}/bin"
    for prg in *; do
      rm -f "$out/bin/$prg"
      makeWrapper "${python}/bin/$prg" "$out/bin/$prg" --set PYTHONHOME "$out"
    done
  '' + postBuild;
}) // {
  inherit python;
  inherit (python) meta;
}
