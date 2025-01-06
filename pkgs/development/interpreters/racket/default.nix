{
  lib,
  stdenv,
  fetchurl,

  libiconvReal,
  libz,
  lz4,
  ncurses,
  openssl,

  isMinimal ? false,

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
  writers,
}:

let
  makeLibPaths = lib.concatMapStringsSep " " (
    lib.flip lib.pipe [
      lib.getLib
      (x: ''"${x}/lib"'')
    ]
  );

  manifest = lib.importJSON ./manifest.json;
  inherit (stdenv.hostPlatform) isDarwin isStatic;

  runtimeDeps = [ openssl ];
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

stdenv.mkDerivation (finalAttrs: {
  pname = "racket";
  inherit (manifest) version;

  src =
    let
      info = manifest.${if isMinimal then "minimal" else "full"};
    in
    fetchurl {
      url = "https://mirror.racket-lang.org/installers/${manifest.version}/${info.filename}";
      inherit (info) sha256;
    };

  nativeBuildInputs = lib.optionals (!isMinimal) [
    wrapGAppsHook3
  ];

  buildInputs = [
    libiconvReal
    libz
    lz4
    ncurses
  ];

  patches = lib.optionals isDarwin [
    /*
      The entry point binary $out/bin/racket is codesigned at least once. The
      following error is triggered as a result.
      (error 'add-ad-hoc-signature "file already has a signature")
      We always remove the existing signature then call add-ad-hoc-signature to
      circumvent this error.
    */
    ./patches/force-remove-codesign-then-add.patch
  ];

  preConfigure =
    /*
      The configure script forces using `libtool -o` as AR on Darwin. But, the
      `-o` option is only available from Apple libtool. GNU ar works here.
    */
    lib.optionalString isDarwin ''
      substituteInPlace src/ChezScheme/zlib/configure \
          --replace-fail 'ARFLAGS="-o"' 'AR=ar; ARFLAGS="rc"'
    ''
    + ''
      mkdir src/build
      cd src/build
    '';

  configureScript = "../configure";

  configureFlags =
    [
      "--enable-check"
      "--enable-csonly"
      "--enable-liblz4"
      "--enable-libz"
    ]
    ++ lib.optional disableDocs "--disable-docs"
    ++ lib.optionals (!isStatic) [
      # instead of `--disable-static` that `stdenv` assumes
      "--disable-libs"
      # "not currently supported" in `configure --help-cs` but still emphasized in README
      "--enable-shared"
    ]
    ++ lib.optionals isDarwin [
      "--disable-strip"
      # "use Unix style (e.g., use Gtk) for Mac OS", which eliminates many problems
      "--enable-xonx"
    ];

  preBuild =
    let
      libPaths = makeLibPaths mainDistDeps;
      libPathsVar = if isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    lib.optionalString (!isMinimal) (
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
      ''
    );

  dontStrip = isDarwin;

  preFixup = lib.optionalString (!isMinimal && !isDarwin) ''
    gappsWrapperArgs+=("--set" "LOCALE_ARCHIVE" "${glibcLocales}/lib/locale/locale-archive")
  '';

  postFixup =
    let
      libPaths = makeLibPaths (runtimeDeps ++ lib.optionals (!isMinimal) mainDistDeps);
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

  passthru = {
    # Functionalities #
    updateScript = {
      command = ./update.py;
      attrPath = "racket";
      supportedFeatures = [ "commit" ];
    };
    writeScript =
      nameOrPath:
      {
        libraries ? [ ],
        ...
      }@config:
      assert lib.assertMsg (libraries == [ ]) "library integration for Racket has not been implemented";
      writers.makeScriptWriter (
        builtins.removeAttrs config [ "libraries" ]
        // {
          interpreter = "${lib.getExe finalAttrs.finalPackage}";
        }
      ) nameOrPath;
    writeScriptBin = name: finalAttrs.passthru.writeScript "/bin/${name}";

    # Tests #
    tests = builtins.mapAttrs (name: path: callPackage path { racket = finalAttrs.finalPackage; }) (
      {
        ## Basic ##
        write-greeting = ./tests/write-greeting.nix;
        get-version-and-variant = ./tests/get-version-and-variant.nix;
        load-openssl = ./tests/load-openssl.nix;

        ## Nixpkgs supports ##
        nix-write-script = ./tests/nix-write-script.nix;
      }
      // lib.optionalAttrs (!isMinimal) {
        ## `main-distribution` ##
        draw-crossing = ./tests/draw-crossing.nix;
      }
    );
  };

  meta = {
    description =
      "Programmable programming language" + lib.optionalString isMinimal " (minimal distribution)";
    longDescription =
      ''
        Racket is a full-spectrum programming language. It goes beyond
        Lisp and Scheme with dialects that support objects, types,
        laziness, and more. Racket enables programmers to link
        components written in different dialects, and it empowers
        programmers to create new, project-specific dialects. Racket's
        libraries support applications from web servers and databases to
        GUIs and charts.
      ''
      + lib.optionalString isMinimal ''

        This minimal distribution includes just enough of Racket that you can
        use `raco pkg` to install more.
      '';
    homepage = "https://racket-lang.org/";
    changelog = "https://github.com/racket/racket/releases/tag/v${finalAttrs.version}";
    /*
      > Racket is distributed under the MIT license and the Apache version 2.0
      > license, at your option.

      > The Racket runtime system embeds Chez Scheme, which is distributed
      > under the Apache version 2.0 license.
    */
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ rc-zb ];
    mainProgram = "racket";
    platforms = lib.platforms.${if isMinimal then "all" else "unix"};
    badPlatforms = lib.platforms.darwin;
  };
})
