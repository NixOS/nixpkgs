{ stdenv, fetchurl, fetchpatch, pkgconfig, gnome3, gtk3, libxml2, intltool, itstool, gdb,
  boost, sqlite, gconf, libgtop, glibmm, gtkmm, vte, gtksourceview,
  gtksourceviewmm, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "nemiver-${version}";
  version = "0.9.6";

  src = fetchurl {
    url = "mirror://gnome/sources/nemiver/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "85ab8cf6c4f83262f441cb0952a6147d075c3c53d0687389a3555e946b694ef2";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "nemiver"; attrPath = "gnome3.nemiver"; };
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ gtk3 libxml2 intltool itstool gdb boost sqlite gconf libgtop
    glibmm gtkmm vte gtksourceview gtksourceviewmm ];

  patches = [
    ./bool_slot.patch ./safe_ptr.patch
    (fetchpatch {
      url = "https://git.gnome.org/browse/nemiver/patch/src/persp/dbgperspective/nmv-dbg-perspective.cc?id=262cf9657f9c2727a816972b348692adcc666008";
      sha256 = "03jv6z54b8nzvplplapk4aj206zl1gvnv6iz0mad19g6yvfbw7a7";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Nemiver;
    description = "Easy to use standalone C/C++ debugger";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.juliendehos ];
  };
}

