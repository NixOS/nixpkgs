{ stdenv, fetchurl, makeWrapper, pkgconfig, gettext, itstool, libvirt-glib
, glib, gobjectIntrospection, libxml2, gtk3, gtkvnc, libvirt, spice-gtk
, spice-protocol, libsoup, libosinfo, systemd, tracker, tracker-miners, vala
, libcap, yajl, gmp, gdbm, cyrus_sasl, gnome3, librsvg, desktop-file-utils
, mtools, cdrkit, libcdio, libusb, libarchive, acl, libgudev, qemu, libsecret
, libcap_ng, numactl, xen, libapparmor
}:

# TODO: ovirt (optional)

stdenv.mkDerivation rec {
  name = "gnome-boxes-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-boxes/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "d00fc083182963dc1bbdee5e743ceb28ba03fbf5a9ea87c78d29dca5fb5b9210";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-boxes"; attrPath = "gnome3.gnome-boxes"; };
  };

  enableParallelBuilding = true;

  doCheck = true;

  nativeBuildInputs = [
    makeWrapper pkgconfig gettext
  ];

  buildInputs = [
    itstool libvirt-glib glib gobjectIntrospection libxml2 gtk3 gtkvnc
    libvirt spice-gtk spice-protocol libsoup libosinfo systemd
    tracker tracker-miners vala libcap yajl gmp gdbm cyrus_sasl libusb libarchive
    gnome3.defaultIconTheme librsvg desktop-file-utils acl libgudev libsecret
    libcap_ng numactl xen libapparmor
  ];

  preFixup = ''
    for prog in "$out/bin/"*; do
        wrapProgram "$prog" \
            --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
            --prefix XDG_DATA_DIRS : "${gnome3.gnome-themes-standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
            --prefix PATH : "${stdenv.lib.makeBinPath [ mtools cdrkit libcdio qemu ]}"
    done
  '';

  meta = with stdenv.lib; {
    description = "Simple GNOME 3 application to access remote or virtual systems";
    homepage = https://wiki.gnome.org/action/show/Apps/Boxes;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
