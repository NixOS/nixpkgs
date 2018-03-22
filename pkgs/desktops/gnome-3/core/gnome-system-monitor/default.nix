{ stdenv, gettext, fetchurl, pkgconfig, gtkmm3, libxml2, polkit
, bash, gtk3, glib, wrapGAppsHook
, itstool, gnome3, librsvg, gdk_pixbuf, libgtop, systemd }:

stdenv.mkDerivation rec {
  name = "gnome-system-monitor-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1wvgx5p0a29d8yzp7rinpln90pg8vsjagqlvm4cxyhnl5hsdvrvn";
  };

  doCheck = true;

  nativeBuildInputs = [
    pkgconfig gettext itstool wrapGAppsHook
    polkit # for ITS file
  ];
  buildInputs = [
    bash gtk3 glib libxml2 gtkmm3 libgtop gdk_pixbuf gnome3.defaultIconTheme librsvg
    gnome3.gsettings-desktop-schemas systemd
  ];

  # fails to build without --enable-static
  configureFlags = ["--enable-systemd" "--enable-static"];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-system-monitor";
      attrPath = "gnome3.gnome-system-monitor";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/SystemMonitor;
    description = "System Monitor shows you what programs are running and how much processor time, memory, and disk space are being used";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
