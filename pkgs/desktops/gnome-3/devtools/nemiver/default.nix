{ stdenv, fetchurl, fetchpatch, pkgconfig, gnome3, gtk3, libxml2, intltool, itstool, gdb,
  boost, sqlite, libgtop, glibmm, gtkmm, vte, gtksourceview, gsettings-desktop-schemas,
  gtksourceviewmm, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "nemiver-${version}";
  version = "0.9.6";

  src = fetchurl {
    url = "mirror://gnome/sources/nemiver/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "85ab8cf6c4f83262f441cb0952a6147d075c3c53d0687389a3555e946b694ef2";
  };

  nativeBuildInputs = [ libxml2 intltool itstool pkgconfig wrapGAppsHook ];

  buildInputs = [
    gtk3 gdb boost sqlite libgtop
    glibmm gtkmm vte gtksourceview gtksourceviewmm
    gsettings-desktop-schemas
  ];

  patches = [
    ./bool_slot.patch
    ./safe_ptr.patch
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/nemiver/commit/262cf9657f9c2727a816972b348692adcc666008.patch;
      sha256 = "03jv6z54b8nzvplplapk4aj206zl1gvnv6iz0mad19g6yvfbw7a7";
    })
  ];

  configureFlags = [
    "--enable-gsettings"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "nemiver";
      attrPath = "gnome3.nemiver";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Nemiver;
    description = "Easy to use standalone C/C++ debugger";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.juliendehos ];
  };
}
