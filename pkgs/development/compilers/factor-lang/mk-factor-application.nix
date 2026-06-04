{
  stdenv,
  lib,
  writeText,
  makeBinaryWrapper,
  factor-lang,
  factor-no-gui,
  factor-unwrapped,
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
    deployScriptText ? /* factor */ ''
      USING: command-line io io.backend io.pathnames kernel namespaces sequences
      tools.deploy tools.deploy.config tools.deploy.config.editor
      tools.deploy.backend vocabs.loader ;

      IN: deploy-me

      : load-and-deploy ( path/vocab -- )
          normalize-path [
              parent-directory add-vocab-root
          ] [
              file-name dup reload deploy
          ] bi ;

      : deploy-vocab ( path/vocab executable -- )
          swap normalize-path
          [ parent-directory add-vocab-root ]
          [ file-name dup reload ] bi
          [ deployed-image-name ] keep
          [ deploy-config ] keep swap
          make-deploy-image-executable drop ;

      : deploy-me ( -- )
          command-line get dup length 2 = [
              first2 deploy-vocab
          ] [
              drop
              "Usage: deploy-me <PATH-TO-VOCAB> <EXECUTABLE-PATH>" print nl
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
      makeBinaryWrapper
      (lib.hiPrio finalAttrs.wrapped-factor)
    ]
    ++ attrs.nativeBuildInputs or [ ];

    buildInputs = (lib.optional enableUI gdk-pixbuf) ++ attrs.buildInputs or [ ];

    buildPhase =
      attrs.buildPhase or /* bash */ ''
        runHook preBuild

        vocabBaseName=$(basename "$vocabName")
        export XDG_CACHE_HOME="$TMPDIR/.cache"
        mkdir -p "$out/bin" "$XDG_CACHE_HOME"

        runHook postBuild
      '';

    __structuredAttrs = true;

    installPhase =
      attrs.installPhase or /* bash */ ''
        runHook preInstall

        ${lib.optionalString finalAttrs.enableUI /* bash */ ''
          # Set Gdk pixbuf loaders file to the one from the build dependencies here
          unset GDK_PIXBUF_MODULE_FILE
          # Defined in gdk-pixbuf setup hook
          findGdkPixbufLoaders "${librsvg}"
          appendToVar makeWrapperArgs --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
          appendToVar makeWrapperArgs --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
        ''}
        ${lib.optionalString (wrapped-factor.runtimeLibs != [ ]) /* bash */ ''
          appendToVar makeWrapperArgs --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath wrapped-factor.runtimeLibs}"
        ''}

        mkdir -p "$out/bin"

        # Stage copy of the raw VM binary into the output directory with correct
        # permissions for embed-image to modify in place
        install -m755 "${lib.getLib factor-unwrapped}/lib/factor/factor" "$out/bin/$binName"

        wrapProgram "$out/bin/$binName" \
          --prefix PATH : "${lib.makeBinPath runtimePaths}" \
          "''${makeWrapperArgs[@]}"

        runHook postInstall
      '';

    # strip & patchelf in base fixupPhase rewrite the the ELF — *including*
    # appended sections like the magic footer bits Factor writes — so the
    # deploy script must be be run after
    postFixup =
      attrs.postFixup or /* bash */ ''
        factor "${deployScript}" "./$vocabName" "$out/bin/.$binName-wrapped"
      '';

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
