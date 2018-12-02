{ stdenv, fetchurl, pkgconfig, gtkmm3, glibmm, gtksourceview3, gnome3 }:

stdenv.mkDerivation rec {
  name = "gtksourceviewmm-${version}";
  version = "3.21.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceviewmm/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1danc9mp5mnb65j01qxkwj92z8jf1gns41wbgp17qh7050f0pc6v";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtksourceviewmm";
      attrPath = "gnome3.gtksourceviewmm";
      versionPolicy = "none";
    };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glibmm gtkmm3 gtksourceview3 ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://developer.gnome.org/gtksourceviewmm/;
    description = "C++ wrapper for gtksourceview";
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}

