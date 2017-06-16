# Create a derivation that contains aspell and selected dictionaries.
# Composition is done using `pkgs.buildEnv`.

{ aspell
, buildEnv
, makeWrapper
, aspellDicts
}:

f:

let
  dicts = f aspellDicts;
in buildEnv {
  name = "aspell-env";
  paths = [ aspell ] ++ dicts;
  buildInputs = [ makeWrapper ];
  postBuild = ''
    # Remove the symbolic link to /bin and construct wrappers
    rm $out/bin
    mkdir -p $out/bin
    pushd "${aspell}/bin"
    for prg in *; do
      if [ -f "$prg" ]; then
        makeWrapper "${aspell}/bin/$prg" "$out/bin/$prg" --set ASPELL_CONF "data-dir $out/lib/aspell"
      fi
    done
    popd
  '';
}
