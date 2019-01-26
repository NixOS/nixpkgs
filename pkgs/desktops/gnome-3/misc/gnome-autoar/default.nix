{ stdenv, fetchurl, pkgconfig, gnome3
, gtk3, glib, gobject-introspection, libarchive
}:

stdenv.mkDerivation rec {
  name = "gnome-autoar-${version}";
  version = "0.2.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-autoar/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "02i4zgqqqj56h7bcys6dz7n78m4nj2x4dv1ggjmnrk98n06xpsax";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-autoar"; attrPath = "gnome3.gnome-autoar"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib ];
  propagatedBuildInputs = [ libarchive gobject-introspection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.lgpl21;
    description = "Library to integrate compressed files management with GNOME";
  };
}
