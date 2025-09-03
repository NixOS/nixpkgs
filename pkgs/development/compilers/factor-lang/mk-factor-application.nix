{
  stdenv,
  lib,
  writeText,
  makeWrapper,
  factor-lang,
  factor-no-gui,
  librsvg,
  gdk-pixbuf,
}@initAttrs:

drvArgs:

let
  flang = factor-lang; # workaround to satisfy nixf-tidy
in
(stdenv.mkDerivation drvArgs).overrideAttrs (
  finalAttrs:
  {
    name ? "${finalAttrs.pname}-${finalAttrs.version}",
    factor-lang ? if enableUI then flang else factor-no-gui,
    enableUI ? false,
    # Allow overriding the path to the deployed vocabulary name.  A
    # $vocabName.factor file must exist!
    vocabName ? finalAttrs.pname or name,
    # Allow overriding the binary name
    binName ? lib.last (lib.splitString "/" vocabName),
    # Extra libraries needed
    extraLibs ? [ ],
    # Extra binaries in PATH
    extraPaths ? [ ],
    # Extra vocabularies needed by this application
    extraVocabs ? [ ],
    deployScriptText ? ''
      USING: command-line io io.backend io.pathnames kernel namespaces sequences
      tools.deploy tools.deploy.config tools.deploy.backend vocabs.loader ;

      IN: deploy-me

      : load-and-deploy ( path/vocab -- )
          normalize-path [
              parent-directory add-vocab-root
          ] [
              file-name dup reload deploy
          ] bi ;

      : deploy-vocab ( path/vocab path/target -- )
          normalize-path deploy-directory set
          f open-directory-after-deploy? set
          load-and-deploy ;

      : deploy-me ( -- )
          command-line get dup length 2 = [
              first2 deploy-vocab
          ] [
              drop
              "usage: deploy-me <PATH-TO-VOCAB> <TARGET-DIR>" print
              nl
          ] if ;

      MAIN: deploy-me
    '',
    ...
  }@attrs:
  let
    deployScript = writeText "deploy-me.factor" finalAttrs.deployScriptText;
    wrapped-factor = finalAttrs.factor-lang.override {
      inherit (finalAttrs) extraLibs extraVocabs;
      doInstallCheck = false;
    };
    runtimePaths = with finalAttrs.wrapped-factor; defaultBins ++ binPackages ++ finalAttrs.extraPaths;
  in
  {
    inherit
      enableUI
      vocabName
      deployScriptText
      extraLibs
      extraPaths
      extraVocabs
      binName
      factor-lang
      wrapped-factor
      ;
    nativeBuildInputs = [
      makeWrapper
      (lib.hiPrio finalAttrs.wrapped-factor)
    ]
    ++ attrs.nativeBuildInputs or [ ];

    buildInputs = (lib.optional enableUI gdk-pixbuf) ++ attrs.buildInputs or [ ];

    buildPhase =
      attrs.buildPhase or ''
        runHook preBuild
        vocabBaseName=$(basename "$vocabName")
        mkdir -p "$out/lib/factor" "$TMPDIR/.cache"
        export XDG_CACHE_HOME="$TMPDIR/.cache"

        factor "${deployScript}" "./$vocabName" "$out/lib/factor"
        cp "$TMPDIR/factor-temp"/*.image "$out/lib/factor/$vocabBaseName"
        runHook postBuild
      '';

    __structuredAttrs = true;

    installPhase =
      attrs.installPhase or (
        ''
          runHook preInstall
        ''
        + (lib.optionalString finalAttrs.enableUI ''
          # Set Gdk pixbuf loaders file to the one from the build dependencies here
          unset GDK_PIXBUF_MODULE_FILE
          # Defined in gdk-pixbuf setup hook
          findGdkPixbufLoaders "${librsvg}"
          appendToVar makeWrapperArgs --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
          appendToVar makeWrapperArgs --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
        '')
        + (lib.optionalString (wrapped-factor.runtimeLibs != [ ])) ''
          appendToVar makeWrapperArgs --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath wrapped-factor.runtimeLibs}"
        ''
        + ''
          mkdir -p "$out/bin"
          makeWrapper "$out/lib/factor/$vocabBaseName/$vocabBaseName" \
            "$out/bin/$binName" \
            --prefix PATH : "${lib.makeBinPath runtimePaths}" \
            "''${makeWrapperArgs[@]}"
          runHook postInstall
        ''
      );

    passthru = {
      vocab = finalAttrs.src;
    }
    // attrs.passthru or { };

    meta = {
      platforms = wrapped-factor.meta.platforms;
      mainProgram = finalAttrs.binName;
    }
    // attrs.meta or { };
  }
)
