{ stdenv, fetchurl, pkgconfig, intltool, libtool
, glib, dbus, udev, libgudev, udisks2, libgcrypt, libcap, polkit
, libgphoto2, avahi, libarchive, fuse, libcdio, file, bzip2, lzma
, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_42, samba, libmtp
, gnomeSupport ? false, gnome, makeWrapper }:

let
  ver_maj = "1.34";
  version = "${ver_maj}.1";
in
stdenv.mkDerivation rec {
  name = "gvfs-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${ver_maj}/${name}.tar.xz";
    sha256 = "1d3j6f252mk316hrspwy63inrhxk6l78l4bmlmql401lqapb5yby";
  };

  nativeBuildInputs = [
    pkgconfig intltool libtool file makeWrapper
    libxml2 libxslt docbook_xsl docbook_xml_dtd_42
  ];

  buildInputs =
    [ glib dbus udev libgudev udisks2 libgcrypt
      libgphoto2 avahi libarchive fuse libcdio lzma bzip2
      samba libmtp libcap polkit
      # ToDo: a ligther version of libsoup to have FTP/HTTP support?
    ] ++ stdenv.lib.optionals gnomeSupport (with gnome; [
      libsoup libgnome-keyring gconf gcr
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
