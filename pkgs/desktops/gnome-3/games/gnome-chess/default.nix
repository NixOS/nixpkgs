{ stdenv, fetchurl, meson, ninja, vala, pkgconfig, wrapGAppsHook, gobject-introspection
, gettext, itstool, libxml2, python3, gnome3, glib, gtk3, librsvg }:

stdenv.mkDerivation rec {
  pname = "gnome-chess";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "10y248xdjx9b0izxii9fjyvkra65jxfx66ivwznmn0cadda9gdqg";
  };

  nativeBuildInputs = [ meson ninja vala pkgconfig gettext itstool libxml2 python3 wrapGAppsHook gobject-introspection ];
  buildInputs = [ glib gtk3 librsvg gnome3.adwaita-icon-theme ];

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
    homepage = "https://wiki.gnome.org/Apps/Chess";
    description = "Play the classic two-player boardgame of chess";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
