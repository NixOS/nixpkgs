{ stdenv, fetchurl, pkgconfig, gnome3
, gtk3, glib, gobjectIntrospection, libarchive
}:

stdenv.mkDerivation rec {
  name = "gnome-autoar-${version}";
  version = "0.2.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-autoar/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "e1fe2c06eed30305c38bf0939c72b0e51b4716658e2663a0cf4a4bf57874ca62";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-autoar"; attrPath = "gnome3.gnome-autoar"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib ];
  propagatedBuildInputs = [ libarchive gobjectIntrospection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.lgpl21;
    description = "Library to integrate compressed files management with GNOME";
  };
}
