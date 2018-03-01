{ stdenv, fetchurl, meson, ninja, pkgconfig, wrapGAppsHook
, gettext, libxml2, gnome3, gtk, evolution-data-server, libsoup
, glib, gnome-online-accounts, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "gnome-calendar-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calendar/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "19a2c737b9662be926fb68e7dc731d94c523d23fa7a49e435e6a0346770dc50e";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-calendar"; attrPath = "gnome3.gnome-calendar"; };
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ meson ninja pkgconfig gettext libxml2 wrapGAppsHook ];
  buildInputs = [
    gtk evolution-data-server libsoup glib gnome-online-accounts
    gsettings-desktop-schemas gnome3.defaultIconTheme
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Calendar;
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
