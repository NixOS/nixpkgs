{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, glib
, python3
, sqlite
, gdk_pixbuf
, gnome3
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gom";
  version = "0.3.3";

  outputs = [ "out" "py" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1n1n226dyb3q98216aah87in9hhjcwsbpspsdqqfswz2bx5y6mxc";
  };

  patches = [
    # Needed to apply the next patch
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gom/commit/e8b7c314ce61d459132cf03c9e455d2a01fdc6ea.patch";
      sha256 = "0d7g3nm5lrfhfx9ly8qgf5bfp12kvr7m1xmlgin2q8vqpn0r2ggp";
    })
    # https://gitlab.gnome.org/GNOME/gom/merge_requests/3
    (fetchpatch {
      url = "https://gitlab.gnome.org/worldofpeace/gom/commit/b621c15600b1c32826c9878565eb2398a50907f2.patch";
      sha256 = "1hqck9bb7sxn4akisnn26sbddlphjsavgksick5k4h3rsc0xwx1v";
    })
    ./longer-stress-timeout.patch
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    gdk_pixbuf
    glib
    sqlite
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Dpygobject-override-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A GObject to SQLite object mapper";
    homepage = https://wiki.gnome.org/Projects/Gom;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
