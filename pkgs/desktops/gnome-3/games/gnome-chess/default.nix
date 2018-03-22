{ stdenv, fetchurl, meson, ninja, vala, pkgconfig, wrapGAppsHook, gobjectIntrospection
, gettext, itstool, libxml2, gnome3, glib, gtk3, librsvg }:

stdenv.mkDerivation rec {
  name = "gnome-chess-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1vxgb36njv4v3bgdpwxd89rvr6s6pkbh9d3xislxqry2yp4f03w0";
  };

  nativeBuildInputs = [ meson ninja vala pkgconfig gettext itstool libxml2 wrapGAppsHook gobjectIntrospection ];
  buildInputs = [ glib gtk3 librsvg gnome3.defaultIconTheme ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-chess";
      attrPath = "gnome3.gnome-chess";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Chess;
    description = "Play the classic two-player boardgame of chess";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
