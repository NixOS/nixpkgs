{ stdenv, fetchurl, gettext, meson, ninja, pkgconfig, gobject-introspection, python3
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_43, glibcLocales
, libxml2, upower, glib, wrapGAppsHook, vala, sqlite, libxslt, libstemmer
, gnome3, icu, libuuid, networkmanager, libsoup, json-glib, systemd, dbus
, substituteAll }:

stdenv.mkDerivation rec {
  pname = "tracker";
  version = "2.3.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0vai0qz9jn3z5dlzysynwhbbmslp84ygdql81f5wfxxr98j54yap";
  };

  nativeBuildInputs = [
    meson ninja vala pkgconfig gettext libxslt wrapGAppsHook gobject-introspection
    gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_43 glibcLocales
    python3 # for data-generators
    systemd # used for checks to install systemd user service
    dbus # used for checks and pkgconfig to install dbus service/s
  ];

  buildInputs = [
    glib libxml2 sqlite upower icu networkmanager libsoup libuuid json-glib libstemmer
  ];

  mesonFlags = [
    # TODO: figure out wrapping unit tests, some of them fail on missing gsettings-desktop-schemas
    "-Dfunctional_tests=false"
    "-Ddocs=true"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gdbus = "${glib.bin}/bin/gdbus";
    })
  ];

  postPatch = ''
    patchShebangs utils/g-ir-merge/g-ir-merge
    patchShebangs utils/data-generators/cc/generate
  '';

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
