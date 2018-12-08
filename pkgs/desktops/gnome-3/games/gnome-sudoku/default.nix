{ stdenv, fetchurl, meson, ninja, vala, pkgconfig, gobject-introspection, gettext, gtk3, gnome3, wrapGAppsHook
, json-glib, qqwing, itstool, libxml2, python3, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gnome-sudoku-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sudoku/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1xy986s51jnrcqwan2hy4bjdg6797yr9s7gxx2z2q4j4gkx3qa1f";
  };

  nativeBuildInputs = [ meson ninja vala pkgconfig gobject-introspection gettext itstool libxml2 python3 desktop-file-utils wrapGAppsHook ];
  buildInputs = [ gtk3 gnome3.libgee json-glib qqwing ];

  postPatch = ''
    chmod +x post_install.py # patchShebangs requires executable file
    patchShebangs post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-sudoku";
      attrPath = "gnome3.gnome-sudoku";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Sudoku;
    description = "Test your logic skills in this number grid puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
