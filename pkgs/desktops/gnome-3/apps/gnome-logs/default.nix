{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, itstool, libxml2, systemd }:

stdenv.mkDerivation rec {
  name = "gnome-logs-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "e17ca011e7bea756bd841e027e56cfe8c214bed4817cb35732ace4aa73ff8f5c";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-logs"; attrPath = "gnome3.gnome-logs"; };
  };

  configureFlags = [ "--disable-tests" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool libxml2
    systemd gnome3.gsettings-desktop-schemas gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Logs;
    description = "A log viewer for the systemd journal";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
