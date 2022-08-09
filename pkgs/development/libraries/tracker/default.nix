{ stdenv
, lib
, fetchurl
, gettext
, meson
, ninja
, pkg-config
, asciidoc
, gobject-introspection
, python3
, docbook-xsl-nons
, docbook_xml_dtd_45
, libxml2
, glib
, wrapGAppsNoGuiHook
, sqlite
, libxslt
, libstemmer
, gnome
, icu
, libuuid
, libsoup
, libsoup_3
, json-glib
, systemd
, dbus
, writeText
}:

stdenv.mkDerivation rec {
  pname = "tracker";
  version = "3.4.0.beta";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "r7evHXAHaELU6Fg691l6qJG9phTqiyjmAwiT/gxSpiE=";
  };

  postPatch = ''
    patchShebangs utils/data-generators/cc/generate
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    asciidoc
    gettext
    libxslt
    wrapGAppsNoGuiHook
    gobject-introspection
    docbook-xsl-nons
    docbook_xml_dtd_45
    (python3.pythonForBuild.withPackages (p: [ p.pygobject3 ]))
  ];

  buildInputs = [
    gobject-introspection
    glib
    libxml2
    sqlite
    icu
    libsoup
    libsoup_3
    libuuid
    json-glib
    libstemmer
    dbus
  ] ++ lib.optionals stdenv.isLinux [
    systemd
  ];

  mesonFlags = [
    "-Ddocs=true"
  ] ++ (
    let
      # https://gitlab.gnome.org/GNOME/tracker/-/blob/master/meson.build#L159
      crossFile = writeText "cross-file.conf" ''
        [properties]
        sqlite3_has_fts5 = '${lib.boolToString (lib.hasInfix "-DSQLITE_ENABLE_FTS3" sqlite.NIX_CFLAGS_COMPILE)}'
      '';
    in
    [
      "--cross-file=${crossFile}"
    ]
  ) ++ lib.optionals (!stdenv.isLinux) [
    "-Dsystemd_user_services=false"
  ];

  doCheck = true;

  preCheck =
    let
      linuxDot0 = lib.optionalString stdenv.isLinux ".0";
      darwinDot0 = lib.optionalString stdenv.isDarwin ".0";
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
      ln -s $PWD/src/libtracker-sparql/libtracker-sparql-3.0${darwinDot0}${extension} $out/lib/libtracker-sparql-3.0${darwinDot0}${extension}${linuxDot0}
    '';

  checkPhase = ''
    runHook preCheck

    dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test \
        --timeout-multiplier 2 \
        --print-errorlogs

    runHook postCheck
  '';

  postCheck = ''
    # Clean up out symlinks
    rm -r $out/lib
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Tracker";
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
