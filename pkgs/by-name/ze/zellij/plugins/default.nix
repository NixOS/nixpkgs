{
  lib,
  callPackage,
  nix-update-script,
  stdenvNoCC,
  zellij,
}:
let
  # wrapper for changing the output path from directory to single file
  # from /nix/store/...-zsm-static-wasm32-unknown-wasi-0.4.1/bin/zsm.wasm
  # to   /nix/store/...-zellij-plugin-zsm-0.4.1.wasm
  wrapper =
    attrName: pkg:
    assert lib.assertMsg (
      !((lib.hasAttr "runtimeDeps" pkg) && (!lib.hasAttr "runtimeDeps" pkg.passthru))
    ) "Plugin ${pkg.pname} has specified `runtimeDeps` instead of `passthru.runtimeDeps`";
    stdenvNoCC.mkDerivation (finalAttrs: {
      inherit (pkg)
        pname
        version
        ;
      name = "zellij-plugin-${finalAttrs.pname}-${finalAttrs.version}.wasm";

      src = pkg;

      dontUnpack = true;
      buildPhase = ''
        resultFile=$(find "$src" -name '*.wasm')
        if [ $(echo "$resultFile" | wc -l) -ne 1 ]; then
          echo "The unwrapped plugin ($src) contains more than one WASM file"
          echo "$resultFile"
          exit 1
        fi

        # there should probably be `ln -s` here, but it produces a permission error for me
        cp "$resultFile" "$out"
      '';

      passthru = pkg.passthru or { } // {
        unwrapped = pkg;
        updateScript = pkg.passthru.updateScript or nix-update-script {
          attrPath = "zellijPlugins.${attrName}.unwrapped";
        };
      };

      meta = pkg.meta // {
        maintainers = pkg.meta.maintainers or [ ] ++ [ lib.maintainers.PerchunPak ];
        platforms = pkg.meta.platforms or zellij.platforms;
      };
    });
  rustPlugins = lib.mapAttrs wrapper (callPackage ./rust { });
in
rustPlugins // { inherit wrapper; }
