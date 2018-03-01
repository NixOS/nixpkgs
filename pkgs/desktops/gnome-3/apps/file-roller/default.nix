{ stdenv, fetchurl, glib, pkgconfig, gnome3, intltool, itstool, libxml2, libarchive
, attr, bzip2, acl, wrapGAppsHook, librsvg, gdk_pixbuf, libnotify, nautilus }:

stdenv.mkDerivation rec {
  name = "file-roller-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "3e677b8e1c2f19aead69cf4fc419a19fc3373aaf5d7bf558b4f077f10bbba8a5";
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
