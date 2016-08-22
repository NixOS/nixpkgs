{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, libxml2, intltool, itstool, gdb,
  boost, sqlite, gconf, libgtop, glibmm, gtkmm, vte, gtksourceview, 
  gtksourceviewmm, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ gtk3 libxml2 intltool itstool gdb boost sqlite gconf libgtop 
    glibmm gtkmm vte gtksourceview gtksourceviewmm ];

  patches = [ ./bool_slot.patch ./safe_ptr.patch ];

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Nemiver";
    description = "Easy to use standalone C/C++ debugger";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.juliendehos ];
  };
}

