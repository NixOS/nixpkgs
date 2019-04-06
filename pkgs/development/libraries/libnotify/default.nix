{ stdenv, fetchurl, meson, ninja, pkgconfig
, glib, gdk_pixbuf, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libnotify";
  version = "0.7.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1371csx0n92g60b5dmai4mmzdnx8081mc3kcgc6a0xipcq5rw839";
  };

  mesonFlags = [
    # disable tests as we don't need to depend on gtk+(2/3)
    "-Dtests=false"
    "-Ddocbook_docs=disabled"
    "-Dgtk_doc=false"
  ];

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection ];
  buildInputs = [ glib gdk_pixbuf ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://developer.gnome.org/notification-spec/;
    description = "A library that sends desktop notifications to a notification daemon";
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
