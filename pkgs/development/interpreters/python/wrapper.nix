{ stdenv, python, buildEnv, makeWrapper, recursivePthLoader, extraLibs ? [] }:

# Create a python executable that knows about additional packages.

(buildEnv {
  name = "python-${python.version}-wrapper";
  paths = extraLibs ++ [ python makeWrapper recursivePthLoader ];
  ignoreCollisions = false;

  postBuild = ''
    . "${makeWrapper}/nix-support/setup-hook"
    mkdir -p "$out/bin"
    cd "${python}/bin"
    for prg in *; do
      echo "$prg --> $out/bin/$prg"
      rm -f "$out/bin/$prg"
      makeWrapper "${python}/bin/$prg" "$out/bin/$prg" --set PYTHONHOME "$out"
    done
  '';
}) // {
  inherit python;
  inherit (python) meta;
}
