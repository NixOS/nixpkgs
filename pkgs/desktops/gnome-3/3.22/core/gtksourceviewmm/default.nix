{ stdenv, fetchurl, pkgconfig, gtkmm, glibmm, gtksourceview }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ pkgconfig glibmm gtkmm gtksourceview ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = "https://developer.gnome.org/gtksourceviewmm/";
    description = "C++ wrapper for gtksourceview";
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}

