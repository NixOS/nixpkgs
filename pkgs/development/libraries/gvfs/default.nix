{ stdenv, fetchurl, pkgconfig, intltool, libtool
, glib, dbus, udev, libgudev, udisks2, libgcrypt, libcap, polkit
, libgphoto2, avahi, libarchive, fuse, libcdio
, libxml2, libxslt, docbook_xsl, samba, libmtp
, gnomeSupport ? false, gnome, makeWrapper }:

let
  ver_maj = "1.30";
  version = "${ver_maj}.1";
in
stdenv.mkDerivation rec {
  name = "gvfs-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${ver_maj}/${name}.tar.xz";
    sha256 = "e752e7bb46e64e4025f63428d4f5247e3e5c0d0b5eeb4f81dbf1cd7b75f59d7b";
  };

  nativeBuildInputs = [ pkgconfig intltool libtool ];

  buildInputs =
    [ makeWrapper glib dbus udev libgudev udisks2 libgcrypt
      libgphoto2 avahi libarchive fuse libcdio
      libxml2 libxslt docbook_xsl samba libmtp libcap polkit
      # ToDo: a ligther version of libsoup to have FTP/HTTP support?
    ] ++ stdenv.lib.optionals gnomeSupport (with gnome; [
      gtk libsoup libgnome_keyring gconf gcr
      # ToDo: not working and probably useless until gnome3 from x-updates
    ]);

  configureFlags = stdenv.lib.optional (!gnomeSupport) "--disable-gcr";

  enableParallelBuilding = true;

  preFixup = ''
    for f in $out/libexec/*; do
      wrapProgram $f \
        ${stdenv.lib.optionalString gnomeSupport "--prefix GIO_EXTRA_MODULES : \"${stdenv.lib.getLib gnome.dconf}/lib/gio/modules\""} \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    description = "Virtual Filesystem support library" + optionalString gnomeSupport " (full GNOME support)";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
