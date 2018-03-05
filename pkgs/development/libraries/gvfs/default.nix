{ stdenv, fetchurl, pkgconfig, intltool, libtool, gnome3
, glib, dbus, udev, libgudev, udisks2, libgcrypt, libcap, polkit
, libgphoto2, avahi, libarchive, fuse, libcdio, file, bzip2, lzma
, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_42, samba, libmtp
, gnomeSupport ? false, gnome, makeWrapper }:

let
  pname = "gvfs";
  version = "1.34.2";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0scn7bmfi27dnn764m090cj999dhda05pd9hnd9pcsfwygmcglv0";
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

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Virtual Filesystem support library" + optionalString gnomeSupport " (full GNOME support)";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ] ++ gnome3.maintainers;
  };
}
