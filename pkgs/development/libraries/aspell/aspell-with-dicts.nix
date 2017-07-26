# Create a derivation that contains aspell and selected dictionaries.
# Composition is done using `pkgs.buildEnv`.

{ aspell
, aspellDicts
, makeWrapper
, symlinkJoin
, runCommand
}:

f:

let
  # Dictionaries we want
  dicts = f aspellDicts;

  # A tree containing the dictionaries
  dictEnv = symlinkJoin {
    name = "aspell-dicts";
    paths = dicts;
  };

in runCommand "aspell-env" {
  buildInputs = [ makeWrapper ];
} ''
  # Construct wrappers in /bin
  mkdir -p $out/bin
  pushd "${aspell}/bin"
  for prg in *; do
    if [ -f "$prg" ]; then
      makeWrapper "${aspell}/bin/$prg" "$out/bin/$prg" --set ASPELL_CONF "data-dir ${dictEnv}/lib/aspell"
    fi
  done
  popd
''
