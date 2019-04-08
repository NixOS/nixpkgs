{ stdenv, fetchurl, fetchFromGitLab, intltool, meson, ninja, pkgconfig, gobject-introspection, python2
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_43, glibcLocales
, libxml2, upower, glib, wrapGAppsHook, vala, sqlite, libxslt, libstemmer
, gnome3, icu, libuuid, networkmanager, libsoup, json-glib }:

let
  pname = "tracker";
  version = "2.1.6";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "143zapq50lggj3mpqg2y4rh1hgnkbn9vgvzpqxr7waiawsmx0awq";
  };

  nativeBuildInputs = [
    meson ninja vala pkgconfig intltool libxslt wrapGAppsHook gobject-introspection
    gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_43 glibcLocales
    python2 # for data-generators
  ];

  buildInputs = [
    glib libxml2 sqlite upower icu networkmanager libsoup libuuid json-glib libstemmer
  ];

  LC_ALL = "en_US.UTF-8";

  mesonFlags = [
    "-Ddbus_services=share/dbus-1/services"
    "-Dsystemd_user_services=lib/systemd/user"
    # TODO: figure out wrapping unit tests, some of them fail on missing gsettings-desktop-schemas
    "-Dfunctional_tests=false"
  ];

  patches = [
    # Always generate tracker-sparql.h in time
    (fetchurl {
      url = https://gitlab.gnome.org/GNOME/tracker/commit/3cbfaa5b374e615098e60eb4430f108b642ebe76.diff;
      sha256 = "0smavzvsglpghggrcl8sjflki13nh7pr0jl2yv6ymbf5hr1c4dws";
    })
  ];

  postPatch = ''
    patchShebangs utils/g-ir-merge/g-ir-merge
    patchShebangs utils/data-generators/cc/generate

    # make .desktop Exec absolute
    patch -p0 <<END_PATCH
    +++ src/tracker-store/tracker-store.desktop.in.in
    @@ -4 +4 @@
    -Exec=gdbus call -e -d org.freedesktop.DBus -o /org/freedesktop/DBus -m org.freedesktop.DBus.StartServiceByName org.freedesktop.Tracker1 0
    +Exec=${glib.dev}/bin/gdbus call -e -d org.freedesktop.DBus -o /org/freedesktop/DBus -m org.freedesktop.DBus.StartServiceByName org.freedesktop.Tracker1 0
    END_PATCH
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
