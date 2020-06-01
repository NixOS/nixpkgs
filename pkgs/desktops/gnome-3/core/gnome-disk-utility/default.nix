{ stdenv, gettext, fetchurl, pkgconfig, udisks2, libsecret, libdvdread
, meson, ninja, gtk3, glib, wrapGAppsHook, python3, libnotify
, itstool, gnome3, libxml2, gsettings-desktop-schemas
, libcanberra-gtk3, libxslt, docbook_xsl, libpwquality, systemd }:

stdenv.mkDerivation rec {
  pname = "gnome-disk-utility";
  version = "3.36.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "055l29z99f4ybgf2plz3biz1bwhlpsjpr0zk3aa6vg5w67r1h6vr";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxslt docbook_xsl
    wrapGAppsHook python3 libxml2
  ];

  buildInputs = [
    gtk3 glib libsecret libpwquality libnotify libdvdread libcanberra-gtk3
    udisks2 gnome3.adwaita-icon-theme systemd
    gnome3.gnome-settings-daemon gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-disk-utility";
      attrPath = "gnome3.gnome-disk-utility";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://en.wikipedia.org/wiki/GNOME_Disks";
    description = "A udisks graphical front-end";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
