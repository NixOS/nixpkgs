{ lib, stdenv, fetchurl, meson, ninja, vala, pkg-config, gobject-introspection, gettext, gtk3, gnome3, wrapGAppsHook
, libgee, json-glib, qqwing, itstool, libxml2, python3, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "gnome-sudoku";
  version = "40.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sudoku/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "0mlk6hixvnvm6zbcgw6y3wav9f011ih5fba78cwpi16nf2wsxbm6";
  };

  nativeBuildInputs = [ meson ninja vala pkg-config gobject-introspection gettext itstool libxml2 python3 desktop-file-utils wrapGAppsHook ];
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

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Sudoku";
    description = "Test your logic skills in this number grid puzzle";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
