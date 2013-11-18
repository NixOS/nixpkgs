{ stdenv, python, buildEnv, makeWrapper, recursivePthLoader, extraLibs ? [], postBuild ? ""
, stdLibs ? stdenv.lib.attrValues python.modules
}:

# Create a python executable that knows about additional packages.

(buildEnv {
  name = "python-${python.version}-wrapper";
  paths = stdenv.lib.filter (x : x ? pythonPath) (stdenv.lib.closePropagation extraLibs) ++ stdLibs ++ [ python recursivePthLoader ];
  ignoreCollisions = false;

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

    if [ -f ${python}/nix-support/setup-hook ]; then
        mkdir -p $out/nix-support/
        ln -sv ${python}/nix-support/setup-hook $out/nix-support
    fi
  '' + postBuild;
}) // {
  inherit python;
  inherit (python) meta;
}
