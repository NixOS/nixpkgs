{ lib
, writeText
, makeWrapper
, factor-lang
, factor-no-gui
, librsvg
, gdk-pixbuf
} @ initAttrs:

{ name ? "${attrs.pname}-${attrs.version}"

, factor-lang ? if enableUI then initAttrs.factor-lang else initAttrs.factor-no-gui

, stdenv ? factor-lang.stdenv

, nativeBuildInputs ? []

, buildInputs ? []

# Allow overriding the deployed vocabulary name. A $vocabName.factor file must exist!
, vocabName ? attrs.pname or name

# Allow overriding the binary name
, binName ? lib.last (lib.splitString "/" vocabName)

# Extra libraries needed, defaults to standard libraries, set [] to disable
, extraLibs ? with factor-lang; defaultLibs ++ runtimeLibs

# Extra binaries in PATH, defaults to standard paths, set [] to disable
, extraPaths ? with factor-lang; defaultBins ++ binPackages

, enableUI ? false

, meta ? {}

, ...
} @ attrs:
let
  deployScript = writeText "deploy-me.factor" ''
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
  '';
in stdenv.mkDerivation ((builtins.removeAttrs attrs [
  "stdenv" "buildPhase" "installPhase"
]) // {
  nativeBuildInputs = [ makeWrapper ] ++ nativeBuildInputs;

  buildInputs  = [
    factor-lang
  ] ++ (lib.optional enableUI gdk-pixbuf)
    ++ buildInputs;

  buildPhase = ''
    runHook preBuild
    vocabBaseName=$(basename "${vocabName}")
    mkdir -p "$out/lib/factor" "$TMPDIR/.cache"
    export XDG_CACHE_HOME="$TMPDIR/.cache"

    ${factor-lang}/bin/factor ${deployScript} "./${vocabName}" "$out/lib/factor"
    cp "$TMPDIR/factor-temp"/*.image "$out/lib/factor/$vocabBaseName"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  '' + (lib.optionalString enableUI ''
    # Set Gdk pixbuf loaders file to the one from the build dependencies here
    unset GDK_PIXBUF_MODULE_FILE
    # Defined in gdk-pixbuf setup hook
    findGdkPixbufLoaders "${librsvg}"
    appendToVar wrapperArgs --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
    appendToVar wrapperArgs --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
  '') + (lib.optionalString (extraLibs != []) ''
    appendToVar wrapperArgs --prefix LD_LIBRARY_PATH : \
        ${lib.makeLibraryPath extraLibs}
  '') + ''
     mkdir -p "$out/bin"
     makeWrapper "$out/lib/factor/$vocabBaseName/$vocabBaseName" "$out/bin/${binName}" \
       --prefix PATH : ${lib.makeBinPath extraPaths} \
       $wrapperArgs
    runHook postInstall
  '';

  passthru.vocab = attrs.src;

  meta = {
    platforms = factor-lang.meta.platforms;
    mainProgram = binName;
  } // meta;
})
