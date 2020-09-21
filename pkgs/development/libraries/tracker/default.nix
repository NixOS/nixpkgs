{ stdenv
, fetchurl
, gettext
, meson
, ninja
, pkgconfig
, asciidoc
, gobject-introspection
, python3
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, docbook_xml_dtd_43
, docbook_xml_dtd_45
, libxml2
, glib
, wrapGAppsHook
, vala
, sqlite
, libxslt
, libstemmer
, gnome3
, icu
, libuuid
, networkmanager
, libsoup
, json-glib
, systemd
, dbus
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "tracker";
  version = "3.0.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0drqsfqc4smfbpjk74iap114yww5cpldfhn4z6b0aavmylalb1kh";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit asciidoc;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkgconfig
    asciidoc
    gettext
    libxslt
    wrapGAppsHook
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook_xml_dtd_45
    python3 # for data-generators
    systemd # used for checks to install systemd user service
    dbus # used for checks and pkgconfig to install dbus service/s
  ];

  buildInputs = [
    glib
    libxml2
    sqlite
    icu
    networkmanager
    libsoup
    libuuid
    json-glib
    libstemmer
  ];

  checkInputs = [
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    # TODO: figure out wrapping unit tests, some of them fail on missing gsettings-desktop-schemas
    # "-Dfunctional_tests=true"
    "-Ddocs=true"
  ];

  doCheck = false;

  postPatch = ''
    patchShebangs utils/g-ir-merge/g-ir-merge
    patchShebangs utils/data-generators/cc/generate
    patchShebangs tests/functional-tests/test-runner.sh.in
    patchShebangs tests/functional-tests/*.py
  '';

  preCheck = ''
    # (tracker-store:6194): Tracker-CRITICAL **: 09:34:07.722: Cannot initialize database: Could not open sqlite3 database:'/homeless-shelter/.cache/tracker/meta.db': unable to open database file
    export HOME=$(mktemp -d)

    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running functional tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p $out/lib
    ln -s $PWD/src/libtracker-sparql-backend/libtracker-sparql-2.0.so $out/lib/libtracker-sparql-2.0.so.0
    ln -s $PWD/src/libtracker-miner/libtracker-miner-2.0.so $out/lib/libtracker-miner-2.0.so.0
    ln -s $PWD/src/libtracker-data/libtracker-data.so $out/lib/libtracker-data.so
  '';

  postCheck = ''
    # Clean up out symlinks
    rm -r $out/lib
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/Tracker";
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
