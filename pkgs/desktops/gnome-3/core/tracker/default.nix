{ stdenv, fetchurl, fetchFromGitLab, intltool, meson, ninja, pkgconfig, gobject-introspection, python3
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_43, glibcLocales
, libxml2, upower, glib, wrapGAppsHook, vala, sqlite, libxslt, libstemmer
, gnome3, icu, libuuid, networkmanager, libsoup, json-glib
, substituteAll}:

let
  pname = "tracker";
  version = "2.2.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1zx2mlnsv6clgh0j50f0b94b7cf1al1j7bkcz8cr31a0fkkgkkhc";
  };

  nativeBuildInputs = [
    meson ninja vala pkgconfig intltool libxslt wrapGAppsHook gobject-introspection
    gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_43 glibcLocales
    python3 # for data-generators
  ];

  buildInputs = [
    glib libxml2 sqlite upower icu networkmanager libsoup libuuid json-glib libstemmer
  ];

  LC_ALL = "en_US.UTF-8";

  mesonFlags = [
    "-Ddbus_services=${placeholder ''out''}/share/dbus-1/services"
    "-Dsystemd_user_services=${placeholder ''out''}/lib/systemd/user"
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
