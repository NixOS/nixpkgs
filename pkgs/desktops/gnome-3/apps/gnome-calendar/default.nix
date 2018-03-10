{ stdenv, fetchurl, meson, ninja, pkgconfig, wrapGAppsHook
, gettext, libxml2, gnome3, gtk, evolution-data-server, libsoup
, glib, gnome-online-accounts, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "gnome-calendar-${version}";
  version = "3.26.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calendar/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1clnfvvsaqw9vpxrs6qrxzmgpaw9x2nkjik2x2vwvm07pdvhddxn";
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
