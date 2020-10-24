{ stdenv, fetchurl, meson, ninja, vala, pkgconfig, gobject-introspection, gettext, gtk3, gnome3, wrapGAppsHook
, libgee, json-glib, qqwing, itstool, libxml2, python3, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "gnome-sudoku";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sudoku/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0cpxx63liczmax6ry06r5k0f221xpg2rqh49vkdj2snmqq61swrq";
  };

  nativeBuildInputs = [ meson ninja vala pkgconfig gobject-introspection gettext itstool libxml2 python3 desktop-file-utils wrapGAppsHook ];
  buildInputs = [ gtk3 libgee json-glib qqwing ];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-sudoku";
      attrPath = "gnome3.gnome-sudoku";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Sudoku";
    description = "Test your logic skills in this number grid puzzle";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
