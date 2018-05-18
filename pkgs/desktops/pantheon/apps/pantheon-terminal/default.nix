{ stdenv, fetchurl, perl, cmake, vala_0_38, pkgconfig, glib, gtk3, granite, gnome3, libnotify, gettext, wrapGAppsHook, gobjectIntrospection }:

stdenv.mkDerivation rec {
  majorVersion = "0.4";
  minorVersion = "3";
  name = "pantheon-terminal-${majorVersion}.${minorVersion}";
  src = fetchurl {
    url = "https://launchpad.net/pantheon-terminal/${majorVersion}.x/${majorVersion}.${minorVersion}/+download/${name}.tgz";
    sha256 = "0bfrqxig26i9qhm15kk7h9lgmzgnqada5snbbwqkp0n0pnyyh4ss";
  };

  nativeBuildInputs = [
    perl cmake vala_0_38 pkgconfig wrapGAppsHook
    # For setup hook
    gobjectIntrospection
  ];
  buildInputs = with gnome3; [
    glib gtk3 granite libnotify gettext vte_290 libgee
    gsettings-desktop-schemas defaultIconTheme
  ];
  meta = {
    description = "Elementary OS's terminal";
    longDescription = "A super lightweight, beautiful, and simple terminal. It's designed to be setup with sane defaults and little to no configuration. It's just a terminal, nothing more, nothing less. Designed for elementary OS.";
    homepage = https://launchpad.net/pantheon-terminal;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vozz ];
  };
}
