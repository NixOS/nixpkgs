# Create a derivation that contains aspell and selected dictionaries.
# Composition is done using `pkgs.buildEnv`.

{ aspell
, aspellDicts
, makeWrapper
, buildEnv
}:

f:

let
  # Dictionaries we want
  dicts = f aspellDicts;

in buildEnv {
  name = "aspell-env";
  buildInputs = [ makeWrapper ];
  paths = [ aspell ] ++ dicts;
  postBuild = ''
    # Construct wrappers in /bin
    unlink "$out/bin"
    mkdir -p "$out/bin"
    pushd "${aspell}/bin"
    for prg in *; do
      if [ -f "$prg" ]; then
        makeWrapper "${aspell}/bin/$prg" "$out/bin/$prg" --set ASPELL_CONF "dict-dir $out/lib/aspell"
      fi
    done
    popd
  '';
}