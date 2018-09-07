{ stdenv, gettext, fetchurl, pkgconfig, udisks2, libsecret, libdvdread
, meson, ninja, gtk, glib, wrapGAppsHook, python3, libnotify
, itstool, gnome3, libxml2
, libcanberra-gtk3, libxslt, docbook_xsl, libpwquality }:

stdenv.mkDerivation rec {
  name = "gnome-disk-utility-${version}";
  version = "3.28.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "11ajz4cbsdns81kihd6242b6pwxbw8bkr9qqkf4qnb4kp363a38m";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-disk-utility"; attrPath = "gnome3.gnome-disk-utility"; };
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxslt docbook_xsl
    wrapGAppsHook python3 libxml2
  ];
  buildInputs = [
    gtk glib libsecret libpwquality libnotify libdvdread libcanberra-gtk3
    udisks2 gnome3.defaultIconTheme
    gnome3.gnome-settings-daemon gnome3.gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://en.wikipedia.org/wiki/GNOME_Disks;
    description = "A udisks graphical front-end";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
