{
  lib,
  stdenv,
  fetchurl,
  racket-minimal,

  openssl,

  cairo,
  fontconfig,
  glib,
  glibcLocales,
  gtk3,
  libGL,
  libiodbc,
  libjpeg,
  libpng,
  makeFontsConf,
  pango,
  sqlite,
  unixODBC,
  wrapGAppsHook3,

  disableDocs ? false,

  callPackage,
}:

let
  minimal = racket-minimal.override { inherit disableDocs; };

  makeLibPaths = lib.concatMapStringsSep " " (
    lib.flip lib.pipe [
      lib.getLib
      (x: ''"${x}/lib"'')
    ]
  );

  manifest = lib.importJSON ./manifest.json;
  inherit (stdenv.hostPlatform) isDarwin;

  runtimeDeps = [
    openssl
  ];

  mainDistDeps = [
    (if isDarwin then libiodbc else unixODBC)
    cairo
    fontconfig
    glib
    gtk3
    libGL
    libjpeg
    libpng
    pango
    sqlite
  ];
in

minimal.overrideAttrs (
  finalAttrs: prevAttrs: {
    src = fetchurl {
      url = "https://mirror.racket-lang.org/installers/${manifest.version}/${manifest.full.filename}";
      inherit (manifest.full) sha256;
    };

    nativeBuildInputs = [
      wrapGAppsHook3
    ];

    preBuild =
      let
        libPaths = makeLibPaths mainDistDeps;
        libPathsVar = if isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH";
      in
      /*
        Makes FFIs available for setting up `main-distribution` and its
        dependencies, which is integrated into the build process of Racket
      */
      ''
        for lib_path in ${libPaths}; do
            addToSearchPath ${libPathsVar} $lib_path
        done
      ''
      # Fixes Fontconfig errors
      + ''
        export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ ]; }}
        export XDG_CACHE_HOME=$(mktemp -d)
      '';

    preFixup = lib.optionalString (!isDarwin) ''
      gappsWrapperArgs+=("--set" "LOCALE_ARCHIVE" "${glibcLocales}/lib/locale/locale-archive")
    '';

    postFixup =
      let
        libPaths = makeLibPaths (runtimeDeps ++ mainDistDeps);
      in
      ''
        $out/bin/racket -f - <<EOF
        (require setup/dirs)

        (define config-path (build-path (find-config-dir) "config.rktd"))

        (define prev-config (with-input-from-file config-path read))
        (define prev-lib-search-dirs (hash-ref prev-config 'lib-search-dirs '(#f)))

        (define lib-search-dirs (append '(${libPaths}) prev-lib-search-dirs))
        (define config (hash-set prev-config 'lib-search-dirs lib-search-dirs))

        (with-output-to-file config-path (thunk (pretty-write config))
          #:exists 'replace)
        EOF
      '';

    passthru =
      let
        notUpdated = x: !builtins.isAttrs x || lib.isDerivation x;
        stopPred =
          _: lhs: rhs:
          notUpdated lhs || notUpdated rhs;
      in
      lib.recursiveUpdateUntil stopPred prevAttrs.passthru {
        tests = builtins.mapAttrs (name: path: callPackage path { racket = finalAttrs.finalPackage; }) {
          ## `main-distribution` ##
          draw-crossing = ./tests/draw-crossing.nix;
        };
      };

    meta = prevAttrs.meta // {
      description = "Programmable programming language";
      longDescription = ''
        Racket is a full-spectrum programming language. It goes beyond
        Lisp and Scheme with dialects that support objects, types,
        laziness, and more. Racket enables programmers to link
        components written in different dialects, and it empowers
        programmers to create new, project-specific dialects. Racket's
        libraries support applications from web servers and databases to
        GUIs and charts.
      '';
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
    };
  }
)
