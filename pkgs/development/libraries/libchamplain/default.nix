{ fetchurl
, fetchpatch
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
  version = "0.12.20";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0rihpb0npqpihqcdz4w03rq6xl7jdckfqskvv9diq2hkrnzv8ch2";
  };

  patches = lib.optionals withLibsoup3 [
    # Port to libsoup3
    # https://gitlab.gnome.org/GNOME/libchamplain/-/merge_requests/13
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libchamplain/-/commit/1cbaf3193c2b38e447fbc383d4c455c3dcac6db8.patch";
      excludes = [ ".gitlab-ci.yml" ];
      sha256 = "uk38gExnUgeUKwhDsqRU77hGWhJ+8fG5dSiV2MAWLFk=";
    })
  ];

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
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
    "-Dgtk_doc=true"
    "-Dvapi=true"
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
