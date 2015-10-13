{ stdenv, fetchurl, pkgconfig, intltool, libtool
, glib, dbus, udev, libgudev, udisks2, libgcrypt
, libgphoto2, avahi, libarchive, fuse, libcdio
, libxml2, libxslt, docbook_xsl, samba, libmtp
, gnomeSupport ? false, gnome,libgnome_keyring, gconf, makeWrapper }:

let
  ver_maj = "1.22";
  version = "${ver_maj}.4";
in
stdenv.mkDerivation rec {
  name = "gvfs-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${ver_maj}/${name}.tar.xz";
    sha256 = "57e33faad35aba72be3822099856aca847f391626cf3ec734b42e64ba31f6484";
  };

  nativeBuildInputs = [ pkgconfig intltool libtool ];

  buildInputs =
    [ makeWrapper glib dbus udev libgudev udisks2 libgcrypt
      libgphoto2 avahi libarchive fuse libcdio
      libxml2 libxslt docbook_xsl samba libmtp
      # ToDo: a ligther version of libsoup to have FTP/HTTP support?
    ] ++ stdenv.lib.optionals gnomeSupport (with gnome; [
      gtk libsoup libgnome_keyring gconf
      # ToDo: not working and probably useless until gnome3 from x-updates
    ]);

  enableParallelBuilding = true;

  # ToDo: one probably should specify schemas for samba and others here
  preFixup = ''
    wrapProgram $out/libexec/gvfsd --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Virtual Filesystem support library" + optionalString gnomeSupport " (full GNOME support)";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
