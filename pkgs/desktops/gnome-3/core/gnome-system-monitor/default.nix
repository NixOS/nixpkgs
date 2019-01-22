{ stdenv, gettext, fetchurl, pkgconfig, gtkmm3, libxml2, polkit
, bash, gtk3, glib, wrapGAppsHook, meson, ninja, python3
, itstool, gnome3, librsvg, gdk_pixbuf, libgtop, systemd }:

stdenv.mkDerivation rec {
  name = "gnome-system-monitor-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0g0y565bjs6bdszrnxsz1f7hcm1x59i3mfvplysirh7nz3hpz888";
  };

  doCheck = true;

  nativeBuildInputs = [
    pkgconfig gettext itstool wrapGAppsHook meson ninja python3
    polkit # for ITS file
  ];
  buildInputs = [
    bash gtk3 glib libxml2 gtkmm3 libgtop gdk_pixbuf gnome3.defaultIconTheme librsvg
    gnome3.gsettings-desktop-schemas systemd
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
    sed -i '/gtk-update-icon-cache/s/^/#/' meson_post_install.py
  '';

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
