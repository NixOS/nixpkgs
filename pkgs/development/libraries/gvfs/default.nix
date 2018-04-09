{ stdenv, meson, ninja, fetchurl, pkgconfig, gettext, gnome3
, glib, libgudev, udisks2, libgcrypt, libcap, polkit
, libgphoto2, avahi, libarchive, fuse, libcdio
, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_42, samba, libmtp
, gnomeSupport ? false, gnome, makeWrapper
, libimobiledevice, libbluray, libcdio-paranoia, libnfs, openssh
, libsecret, libgdata
# Remove when switching back to meson
, autoreconfHook, lzma, bzip2
}:

# TODO: switch to meson when upstream fixes a non-deterministic build failure
# See https://bugzilla.gnome.org/show_bug.cgi?id=794549

# Meson specific things are commented out and annotated, so switching back
# should simply require deleting autotools specific things and adding back meson
# flags etc.

let
  pname = "gvfs";
  version = "1.36.0";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1fsn6aa9a68cfbna9s00l1ry4ym1fr7ii2f45hzj2fipxfpqihwy";
  };

  # Uncomment when switching back to meson
  # postPatch = ''
  #   chmod +x meson_post_install.py # patchShebangs requires executable file
  #   patchShebangs meson_post_install.py
  # '';

  nativeBuildInputs = [
    autoreconfHook # Remove when switching to meson
    # meson ninja
    pkgconfig gettext makeWrapper
    libxml2 libxslt docbook_xsl docbook_xml_dtd_42
  ];

  buildInputs =
    [ glib libgudev udisks2 libgcrypt
      libgphoto2 avahi libarchive fuse libcdio
      samba libmtp libcap polkit libimobiledevice libbluray
      libcdio-paranoia libnfs openssh
      # Remove when switching back to meson
      lzma bzip2
      # ToDo: a ligther version of libsoup to have FTP/HTTP support?
    ] ++ stdenv.lib.optionals gnomeSupport (with gnome; [
      libsoup gcr
      gnome-online-accounts libsecret libgdata
    ]);

  # Remove when switching back to meson
  configureFlags = stdenv.lib.optional (!gnomeSupport) "--disable-gcr";

  # Uncomment when switching back to meson
  # mesonFlags = [
  #   "-Dgio_module_dir=lib/gio/modules"
  #   "-Dsystemduserunitdir=lib/systemd/user"
  #   "-Ddbus_service_dir=share/dbus-1/services"
  #   "-Dtmpfilesdir=no"
  # ] ++ stdenv.lib.optionals (!gnomeSupport) [
  #   "-Dgcr=false" "-Dgoa=false" "-Dkeyring=false" "-Dhttp=false"
  #   "-Dgoogle=false"
  # ] ++ stdenv.lib.optionals (samba == null) [
  #   # Xfce don't want samba
  #   "-Dsmb=false"
  # ];

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
