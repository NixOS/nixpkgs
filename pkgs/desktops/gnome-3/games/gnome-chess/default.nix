{ stdenv, fetchurl, meson, ninja, vala, pkgconfig, wrapGAppsHook, gobject-introspection
, gettext, itstool, libxml2, python3, gnome3, glib, gtk3, librsvg }:

stdenv.mkDerivation rec {
  name = "gnome-chess-${version}";
  version = "3.30.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1gzdm6z54kxx06lh616g33klrp4dby2a68wxvjpsavdll28kgwgl";
  };

  nativeBuildInputs = [ meson ninja vala pkgconfig gettext itstool libxml2 python3 wrapGAppsHook gobject-introspection ];
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
