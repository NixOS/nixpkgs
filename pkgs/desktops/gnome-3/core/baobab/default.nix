{ stdenv, gettext, fetchurl, vala, desktop-file-utils
, meson, ninja, pkgconfig, gtk3, glib, libxml2
, wrapGAppsHook, itstool, gnome3 }:

let
  pname = "baobab";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0qsx7vx5c3n4yxlxbr11sppw7qwcv9z3g45b5xb9y7wxw5lv42sk";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gettext itstool libxml2 desktop-file-utils wrapGAppsHook ];
  buildInputs = [ gtk3 glib gnome3.defaultIconTheme ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    homepage = https://wiki.gnome.org/Apps/DiskUsageAnalyzer;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
