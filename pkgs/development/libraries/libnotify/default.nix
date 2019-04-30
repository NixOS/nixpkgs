{ stdenv, fetchurl, meson, ninja, pkgconfig, fetchpatch
, glib, gdk_pixbuf, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libnotify";
  version = "0.7.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1371csx0n92g60b5dmai4mmzdnx8081mc3kcgc6a0xipcq5rw839";
  };

  patches = [
    # Fix darwin build
    # https://gitlab.gnome.org/GNOME/libnotify/merge_requests/9
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libnotify/commit/55eb69247fe2b479ea43311503042fc03bf4e67d.patch";
      sha256 = "1hlb5b7c5axiyir1i5j2pi94bm2gyr1ybkp6yaqy7yk6iiqlvv50";
    })
  ];

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
