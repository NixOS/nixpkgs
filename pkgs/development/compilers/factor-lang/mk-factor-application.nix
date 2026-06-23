{
  stdenv,
  lib,
  writeText,
  makeBinaryWrapper,
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
    deployScriptText ? /* factor */ ''
      USING: command-line io io.backend io.pathnames kernel namespaces sequences
      tools.deploy tools.deploy.config tools.deploy.backend vocabs.loader
      io.directories.unix ;

      IN: deploy-me

      ! The Nix sandbox’s seccomp filter blocks chmod(2). Factor’s
      ! copy-file calls set-file-permissions which chmod’s the target
      ! to the source’s mode, 0o444. The blocked syscall returns
      ! EACCES, crashing the deploys. The method override skips the
      ! set-file-permissions call (Nix will manage its output
      ! permissions).
      !
      ! Surfaced with Factor 0.101 which added icon PNG resources to
      ! the definitions.icons vocab to copy-vocab-resources.
      M: unix copy-file call-next-method ;

      : load-and-deploy ( path/vocab -- )
          normalize-path [
              parent-directory add-vocab-root
          ] [
              file-name dup reload deploy
          ] bi ;

      ! Factor 0.101 added a .out extension on not macOS. Rather than
      ! having shell scripts dealing path name changes per-OS &
      ! per-version, the deploy script prints its deploy path to a file.
      : deploy-vocab ( path/vocab path/target -- )
          normalize-path deploy-directory set
          f open-directory-after-deploy? set
          dup file-name
          [ load-and-deploy ] dip
          deploy-path "deploy-path.txt" utf8 set-file-contents ;

      : deploy-me ( -- )
          command-line get dup length 2 = [
              first2 deploy-vocab
          ] [
              drop
              "Usage: deploy-me <PATH-TO-VOCAB> <TARGET-DIR>" print
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
      makeBinaryWrapper
      (lib.hiPrio finalAttrs.wrapped-factor)
    ]
    ++ attrs.nativeBuildInputs or [ ];

    buildInputs = (lib.optional enableUI gdk-pixbuf) ++ attrs.buildInputs or [ ];

    buildPhase =
      attrs.buildPhase or /* bash */ ''
        runHook preBuild
        vocabBaseName=$(basename "$vocabName")
        mkdir -p "$out/lib/factor" "$TMPDIR/.cache"
        export XDG_CACHE_HOME="$TMPDIR/.cache"

        # Deploy script writes the deploy path to to $PWD/deploy-path.txt
        factor "${deployScript}" "./$vocabName" "$out/lib/factor"
        deploy_path=$(cat "$PWD/deploy-path.txt")
        if [ ! -x "$deploy_path" ]; then
          echo "Not a valid deploy path for Factor: $deploy_path"
          exit 1
        fi

        cp "$TMPDIR/factor-temp"/*.image "$(dirname "$deploy_path")/$(basename "$deploy_path").image"
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
        makeWrapper "$deploy_path" \
          "$out/bin/$binName" \
          --prefix PATH : "${lib.makeBinPath runtimePaths}" \
          "''${makeWrapperArgs[@]}"
        runHook postInstall
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
