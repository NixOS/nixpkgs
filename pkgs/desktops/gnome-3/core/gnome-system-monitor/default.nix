{ stdenv, gettext, fetchurl, pkgconfig, gtkmm3, libxml2, polkit
, bash, gtk3, glib, wrapGAppsHook, meson, ninja, python3
, gsettings-desktop-schemas, itstool, gnome3, librsvg, gdk-pixbuf, libgtop, systemd }:

stdenv.mkDerivation rec {
  pname = "gnome-system-monitor";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1wd43qdgjav6xamq5z5cy8fri5zr01jga3plc9w95gcia0rk3ha8";
  };

  doCheck = true;

  nativeBuildInputs = [
    pkgconfig gettext itstool wrapGAppsHook meson ninja python3
    polkit # for ITS file
  ];
  buildInputs = [
    bash gtk3 glib libxml2 gtkmm3 libgtop gdk-pixbuf gnome3.adwaita-icon-theme librsvg
    gsettings-desktop-schemas systemd
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
