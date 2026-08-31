{
  runCommand,
  buildTypstPackage,
  typst,
}:

let
  mkPkg =
    pname: typstDeps: entrypointContent:
    buildTypstPackage {
      inherit pname typstDeps;
      version = "0.1.0";
      src =
        runCommand "typst-${pname}-src"
          {
            manifest = ''
              [package]
              name = "${pname}"
              version = "0.1.0"
              entrypoint = "lib.typ"
            '';
            inherit entrypointContent;
          }
          ''
            mkdir -p "$out"
            printf '%s' "$manifest" > "$out/typst.toml"
            printf '%s' "$entrypointContent" > "$out/lib.typ"
          '';
    };

  leaf = mkPkg "test-leaf" [ ] ''
    #let leaf-value = "reached the leaf"
  '';

  mid = mkPkg "test-mid" [ leaf ] ''
    #import "@preview/test-leaf:0.1.0": leaf-value
    #let mid-value = leaf-value
  '';

  top = mkPkg "test-top" [ mid ] ''
    #import "@preview/test-mid:0.1.0": mid-value
    #let top-value = mid-value
  '';

  env =
    (typst.passthru.wrapper.override {
      typstPackages = { inherit leaf mid top; };
    })
      { packages = p: [ p.top ]; };
in
runCommand "typst-transitive-deps"
  {
    nativeBuildInputs = [ env ];
    doc = ''
      #import "@preview/test-top:0.1.0": top-value
      #top-value
    '';
  }
  ''
    root="${env}/lib/typst/packages/preview"
    printf '%s' "$doc" > doc.typ
    mkdir -p $out
    typst compile doc.typ "$out/doc.pdf"
    test -s "$out/doc.pdf"
  ''
