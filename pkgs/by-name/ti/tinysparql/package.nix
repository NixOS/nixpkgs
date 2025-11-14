{
  stdenv,
  lib,
  fetchurl,
  gettext,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  asciidoc,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  vala,
  python3,
  libxml2,
  glib,
  wrapGAppsNoGuiHook,
  sqlite,
  libstemmer,
  gnome,
  icu,
  libuuid,
  libsoup_3,
  json-glib,
  avahi,
  dbus,
  man-db,
  writeText,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinysparql";
  version = "3.10.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url =
      with finalAttrs;
      "mirror://gnome/sources/tinysparql/${lib.versions.majorMinor version}/tinysparql-${version}.tar.xz";
    hash = "sha256-Wn8+eJ22ZxpVDtYoDtT2CmC+p3No2pK+aNx9jX4jAmU=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    asciidoc
    gettext
    glib
    wrapGAppsNoGuiHook
    (python3.pythonOnBuildForHost.withPackages (p: [ p.pygobject3 ]))
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    libxml2
    sqlite
    icu
    libsoup_3
    libuuid
    json-glib
    avahi
    libstemmer
  ];

  nativeCheckInputs = [
    dbus
    man-db
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dsystemd_user_services_dir=${placeholder "out"}/lib/systemd/user"
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "vapi" withIntrospection)
  ]
  ++ (
    let
      # https://gitlab.gnome.org/GNOME/tinysparql/-/blob/3.7.3/meson.build#L170
      crossFile = writeText "cross-file.conf" ''
        [properties]
        sqlite3_has_fts5 = '${lib.boolToString (lib.hasInfix "-DSQLITE_ENABLE_FTS3" sqlite.NIX_CFLAGS_COMPILE)}'
      '';
    in
    [
      "--cross-file=${crossFile}"
    ]
  );

  doCheck = true;

  postPatch = ''
    patchShebangs \
      utils/data-generators/cc/generate

    # File "/build/tinysparql-3.8.0/tests/functional-tests/test_cli.py", line 233, in test_help
    # self.assertIn("TINYSPARQL-IMPORT(1)", output, "Manpage not found")
    # AssertionError: 'TINYSPARQL-IMPORT(1)' not found in '\x1b[4mTINYSPARQL-IMPORT\x1b[24m(1) ...'
    substituteInPlace tests/functional-tests/test_cli.py --replace-fail "TINYSPARQL-IMPORT(1)" "TINYSPARQL-IMPORT"
  '';

  preCheck =
    let
      linuxDot0 = lib.optionalString stdenv.hostPlatform.isLinux ".0";
      darwinDot0 = lib.optionalString stdenv.hostPlatform.isDarwin ".0";
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      # (tracker-store:6194): Tracker-CRITICAL **: 09:34:07.722: Cannot initialize database: Could not open sqlite3 database:'/homeless-shelter/.cache/tracker/meta.db': unable to open database file
      export HOME=$(mktemp -d)

      # Our gobject-introspection patches make the shared library paths absolute
      # in the GIR files. When running functional tests, the library is not yet installed,
      # though, so we need to replace the absolute path with a local one during build.
      # We are using a symlink that will be overridden during installation.
      mkdir -p $out/lib
      ln -s $PWD/src/libtinysparql/libtinysparql-3.0${darwinDot0}${extension} $out/lib/libtinysparql-3.0${darwinDot0}${extension}${linuxDot0}
    '';

  checkPhase = ''
    runHook preCheck

    # The "tinysparql:core / service" test can take 180s+ when builder is in high load.
    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test \
        --timeout-multiplier 0 \
        --print-errorlogs

    runHook postCheck
  '';

  postCheck = ''
    # Clean up out symlinks
    rm -r $out/lib
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = finalAttrs.pname; };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    homepage = "https://tracker.gnome.org/";
    description = "Desktop-neutral user information store, search tool and indexer";
    mainProgram = "tinysparql";
    teams = [ teams.gnome ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    pkgConfigModules = [
      "tracker-sparql-3.0"
      "tinysparql-3.0"
    ];
    # Not before <gio/gdesktopappinfo.h> is properly conditioned.
    broken = stdenv.hostPlatform.isDarwin;
  };
})
