{ lib, stdenv
, fetchurl
, gettext
, meson
, ninja
, pkg-config
, asciidoc
, gobject-introspection
, python3
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_45
, libxml2
, glib
, wrapGAppsNoGuiHook
, vala
, sqlite
, libxslt
, libstemmer
, gnome3
, icu
, libuuid
, libsoup
, json-glib
, systemd
, dbus
, substituteAll
}:

stdenv.mkDerivation (rec {
  pname = "tracker";
  version = "3.0.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-b1yEqzvh7aUgUBsq7XIhYWoM8VKRDFN3V7U4vAXv/KM=";
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
    pkg-config
    asciidoc
    gettext
    libxslt
    wrapGAppsNoGuiHook
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_45
    python3 # for data-generators
    systemd # used for checks to install systemd user service
    dbus # used for checks and pkg-config to install dbus service/s
  ];

  buildInputs = [
    glib
    libxml2
    sqlite
    icu
    libsoup
    libuuid
    json-glib
    libstemmer
  ];

  checkInputs = [
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Ddocs=true"
  ];

  # https://gitlab.gnome.org/GNOME/tracker/-/issues/292#note_1075369
  doCheck = !stdenv.isi686;

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
    ln -s $PWD/src/libtracker-sparql/libtracker-sparql-3.0.so $out/lib/libtracker-sparql-3.0.so.0
  '';

  checkPhase = ''
    runHook preCheck

    dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs

    runHook postCheck
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

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Tracker";
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
  // {
    # TMP: fatal error: libtracker-sparql/tracker-sparql-enum-types.h: No such file or directory
    enableParallelBuilding = false;
  }
)
