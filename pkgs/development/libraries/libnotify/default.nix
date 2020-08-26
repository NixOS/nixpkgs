{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, libxslt
, docbook-xsl-ns
, glib
, gdk-pixbuf
, gobject-introspection
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "libnotify";
  version = "0.7.9";

  outputs = [ "out" "man" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0qa7cx6ra5hwqnxw95b9svgjg5q6ynm8y843iqjszxvds5z53h36";
  };

  mesonFlags = [
    # disable tests as we don't need to depend on GTK (2/3)
    "-Dtests=false"
    "-Ddocbook_docs=disabled"
    "-Dgtk_doc=false"
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    libxslt
    docbook-xsl-ns
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    glib
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://developer.gnome.org/notification-spec/";
    description = "A library that sends desktop notifications to a notification daemon";
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
    license = licenses.lgpl21;
  };
}
