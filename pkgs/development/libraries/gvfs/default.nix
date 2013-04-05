{ stdenv, fetchurl, pkgconfig, intltool, libtool
, glib, dbus, udev, udisks2, libgcrypt
, libgphoto2, avahi, libarchive, fuse, libcdio
, libxml2, libxslt, docbook_xsl
, lightWeight ? true, gnome, samba, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gvfs-1.14.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/1.14/${name}.tar.xz";
    sha256 = "1g4ghyf45jg2ajdkv2d972hbckyjh3d9jdrppai85pl9pk2dmfy3";
  };

  nativeBuildInputs = [ pkgconfig intltool libtool ];

  buildInputs =
    [ makeWrapper glib dbus.libs udev udisks2 libgcrypt
      libgphoto2 avahi libarchive fuse libcdio
      libxml2 libxslt docbook_xsl
      # ToDo: a ligther version of libsoup to have FTP/HTTP support?
    ] ++ stdenv.lib.optionals (!lightWeight) (with gnome; [
      gtk libsoup libgnome_keyring gconf samba
      # ToDo: not working and probably useless until gnome3 from x-updates
    ]);

  enableParallelBuilding = true;

  # ToDo: one probably should specify schemas for samba and others here
  fixupPhase = ''
    wrapProgram $out/libexec/gvfsd --set GSETTINGS_SCHEMA_DIR "$out/share/glib-2.0/schemas"
  '';

  meta = {
    description = "Virtual Filesystem support library" + stdenv.lib.optionalString lightWeight " (light-weight)";
    platforms = stdenv.lib.platforms.linux;
  };
}
