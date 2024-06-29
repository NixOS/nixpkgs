# Create a derivation that contains aspell and selected dictionaries.
# Composition is done using `pkgs.buildEnv`.
# Beware of that `ASPELL_CONF` used by this derivation is not always
# respected by libaspell (#28815) and in some cases, when used as
# dependency by another derivation, the passed dictionaries will be
# missing. However, invoking aspell directly should be fine.

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
  nativeBuildInputs = [ makeWrapper ];
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
