{ fetchurl
, lib
, stdenv
, meson
, ninja
, vala
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, pkg-config
, glib
, gtk3
, cairo
, sqlite
, gnome
, clutter-gtk
, libsoup
, libsoup_3
, gobject-introspection /*, libmemphis */
, withLibsoup3 ? false
}:

stdenv.mkDerivation rec {
  pname = "libchamplain";
  version = "0.12.21";

  outputs = [ "out" "dev" ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "qRXNFyoMUpRMVXn8tGg/ioeMVxv16SglS12v78cn5ac=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
  ] ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs = [
    sqlite
    (if withLibsoup3 then libsoup_3 else libsoup)
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    cairo
    clutter-gtk
  ];

  mesonFlags = [
    (lib.mesonBool "gtk_doc" (stdenv.buildPlatform == stdenv.hostPlatform))
    "-Dvapi=true"
    (lib.mesonBool "libsoup3" withLibsoup3)
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/libchamplain";
    license = licenses.lgpl2Plus;

    description = "C library providing a ClutterActor to display maps";

    longDescription = ''
      libchamplain is a C library providing a ClutterActor to display
       maps.  It also provides a GTK widget to display maps in GTK
       applications.  Python and Perl bindings are also available.  It
       supports numerous free map sources such as OpenStreetMap,
       OpenCycleMap, OpenAerialMap, and Maps for free.
    '';

    maintainers = teams.gnome.members ++ teams.pantheon.members;
    platforms = platforms.gnu ++ platforms.linux; # arbitrary choice
  };
}
