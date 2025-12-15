{
  lib,
  buildEnv,
  typstPackages,
  makeBinaryWrapper,
  typst,
}:
lib.extendMkDerivation {
  constructDrv = buildEnv;
  excludeDrvArgNames = [
    "packages"
    "fonts"
    "extraWrapperArgs"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      packages ? (ps: [ ]),
      fonts ? [ ],
      extraWrapperArgs ? [ ],
    }:
    let
      # Apply the selector
      selectedPkgs = packages typstPackages;
    in
    {
      inherit (typst) version;
      pname = typst.pname + "-env";

      paths = [ typst ] ++ lib.concatMap (p: [ p ] ++ p.propagatedBuildInputs) selectedPkgs;

      pathsToLink = [
        "/lib/typst-packages"
      ];

      derivationArgs = {
        nativeBuildInputs = [ makeBinaryWrapper ];
        typstFonts = fonts;
        typstWrapperArgs = extraWrapperArgs;
      };

      postBuild = ''
        export TYPST_LIB_DIR="$out/lib/typst/packages"
        mkdir -p $TYPST_LIB_DIR

        mv $out/lib/typst-packages $TYPST_LIB_DIR/preview

        cp -r ${typst}/share $out/share
        mkdir -p $out/bin

        makeWrapper "${lib.getExe typst}" "$out/bin/typst" \
          --set TYPST_PACKAGE_CACHE_PATH "$TYPST_LIB_DIR" \
          --set-default TYPST_FONT_PATHS "$(IFS=":"; echo "''${typstWrapperArgs[*]}")" \
          --add-flags "''${typstWrapperArgs[*]}"
      '';

      meta = builtins.removeAttrs typst.meta [ "position" ];
    };
}
