{ stdenv, fetchurl, pkgconfig, gtkmm, glibmm, gtksourceview, gnome3 }:

stdenv.mkDerivation rec {
  name = "gtksourceviewmm-${version}";
  version = "3.21.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceviewmm/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "d21296d8624a1046841bfec082021b7b966df0b62e19ee300828519bc54dd9c6";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gtksourceviewmm"; attrPath = "gnome3.gtksourceviewmm"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glibmm gtkmm gtksourceview ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://developer.gnome.org/gtksourceviewmm/;
    description = "C++ wrapper for gtksourceview";
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}

