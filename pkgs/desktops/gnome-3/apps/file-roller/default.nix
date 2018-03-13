{ stdenv, fetchurl, glib, pkgconfig, gnome3, intltool, itstool, libxml2, libarchive
, attr, bzip2, acl, wrapGAppsHook, librsvg, gdk_pixbuf, libnotify, nautilus }:

stdenv.mkDerivation rec {
  name = "file-roller-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "15pn2m80x45bzibig4zrqybnbr0n1f9wpqx7f2p6difldns3jwf1";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "file-roller"; attrPath = "gnome3.file-roller"; };
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ glib gnome3.gtk intltool itstool libxml2 libarchive
                  gnome3.defaultIconTheme attr bzip2 acl gdk_pixbuf librsvg
                  gnome3.dconf libnotify nautilus ];

  installFlags = [ "nautilus_extensiondir=$(out)/lib/nautilus/extensions-3.0" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/FileRoller;
    description = "Archive manager for the GNOME desktop environment";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
