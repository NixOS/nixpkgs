{ stdenv, fetchurl, gtk2, cairo, glib, pkgconfig, gnome3 }:

stdenv.mkDerivation rec {
  pname = "goocanvas";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "07kicpcacbqm3inp7zq32ldp95mxx4kfxpaazd0x5jk7hpw2w1qw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 cairo glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "Canvas widget for GTK based on the the Cairo 2D library";
    homepage = "https://wiki.gnome.org/Projects/GooCanvas";
    license = licenses.lgpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
