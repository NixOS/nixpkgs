{ stdenv, intltool, fetchurl, pkgconfig, gtkmm3, libxml2
, bash, gtk3, glib, wrapGAppsHook
, itstool, gnome3, librsvg, gdk_pixbuf, libgtop, systemd }:

stdenv.mkDerivation rec {
  name = "gnome-system-monitor-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "f848a8c2ca5e164cf09d3a205dd49e4e4bf4b60d43b0969c10443eb519d0e6b3";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-system-monitor"; attrPath = "gnome3.gnome-system-monitor"; };
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ bash gtk3 glib intltool itstool libxml2
                  gtkmm3 libgtop wrapGAppsHook
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gsettings-desktop-schemas systemd ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3.out}/share:${gnome3.gnome-themes-standard}/share"
    )
  '';

  # fails to build without --enable-static
  configureFlags = ["--enable-systemd" "--enable-static"];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-system-monitor/3.12/;
    description = "System Monitor shows you what programs are running and how much processor time, memory, and disk space are being used";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
