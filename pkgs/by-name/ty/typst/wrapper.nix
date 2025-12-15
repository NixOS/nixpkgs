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
        # The packages
        "/lib/typst-packages"
        # The Typst executable & completions
        "/bin"
        "/share"
      ];

      derivationArgs = {
        nativeBuildInputs = [ makeBinaryWrapper ];
        typstFonts = fonts;
        typstWrapperArgs = extraWrapperArgs;
      };

      postBuild = ''
        wrapProgram "$out/bin/typst" \
          --set-default TYPST_PACKAGE_CACHE_PATH "$out/lib/typst-packages" \
          --set-default TYPST_FONT_PATHS "$(IFS=":"; echo "''${typstWrapperArgs[*]}")" \
          --add-flags "''${typstWrapperArgs[*]}"
      '';

      meta = builtins.removeAttrs typst.meta [ "position" ];
    };
}
