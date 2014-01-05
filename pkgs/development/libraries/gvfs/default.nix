{ stdenv, fetchurl, pkgconfig, intltool, libtool
, glib, dbus, udev, udisks2, libgcrypt
, libgphoto2, avahi, libarchive, fuse, libcdio
, libxml2, libxslt, docbook_xsl
, lightWeight ? true, gnome, samba, makeWrapper }:

let
  ver_maj = "1.18";
  version = "${ver_maj}.3";
in
stdenv.mkDerivation rec {
  name = "gvfs-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${ver_maj}/${name}.tar.xz";
    sha256 = "0b27vidnrwh6yb2ga9a1k9qlrz6lrzsaz2hcxqbc1igivhb9g0hx";
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
