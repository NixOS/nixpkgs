{
  lib,
  buildEnv,
  typstPackages,
  makeBinaryWrapper,
  typst,
}:

lib.makeOverridable (
  { ... }@typstPkgs:
  {
    packages ? (ps: [ ]),
    fonts ? [ ],
    extraWrapperArgs ? [ ],
  }:
  buildEnv {
    inherit (typst) meta;
    name = "${typst.name}-env";

    paths =
      let
        selected = packages typstPkgs;
      in
      map (e: e.pkg) (
        builtins.genericClosure {
          startSet = map (p: {
            key = p.outPath;
            pkg = p;
          }) selected;
          operator =
            { pkg, ... }:
            map (d: {
              key = d.outPath;
              pkg = d;
            }) (pkg.propagatedBuildInputs or [ ]);
        }
      );

    pathsToLink = [ "/lib/typst-packages" ];

    nativeBuildInputs = [ makeBinaryWrapper ];

    postBuild = ''
      export TYPST_LIB_DIR="$out/lib/typst/packages"
      mkdir -p $TYPST_LIB_DIR

      mv $out/lib/typst-packages $TYPST_LIB_DIR/preview

      cp -r ${typst}/share $out/share
      mkdir -p $out/bin

      TYPST_FONT_PATHS=${lib.escapeShellArg (lib.concatStringsSep ":" fonts)}

      makeWrapper "${lib.getExe typst}" "$out/bin/typst" \
        --set TYPST_PACKAGE_CACHE_PATH $TYPST_LIB_DIR \
        ''${TYPST_FONT_PATHS:+--set TYPST_FONT_PATHS "$TYPST_FONT_PATHS"} \
        ${lib.escapeShellArgs extraWrapperArgs}
    '';
  }
) typstPackages
