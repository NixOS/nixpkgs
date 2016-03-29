{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, itstool, libvirt-glib
, glib, gobjectIntrospection, libxml2, gtk3, gtkvnc, libvirt, spice_gtk
, spice_protocol, libuuid, libsoup, libosinfo, systemd, tracker, vala
, libcap_ng, libcap, yajl, gmp, gdbm, cyrus_sasl, gnome3, librsvg
, desktop_file_utils, mtools, cdrkit, libcdio, numactl, xen
, libusb, libarchive, acl, libgudev
}:

# TODO: ovirt (optional)

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  enableParallelBuilding = true;

  doCheck = true;

  buildInputs = [
    makeWrapper pkgconfig intltool itstool libvirt-glib glib
    gobjectIntrospection libxml2 gtk3 gtkvnc libvirt spice_gtk spice_protocol
    libuuid libsoup libosinfo systemd tracker vala libcap_ng libcap yajl gmp
    gdbm cyrus_sasl gnome3.defaultIconTheme libusb libarchive
    librsvg desktop_file_utils acl libgudev numactl xen
  ];

  preFixup = ''
    for prog in "$out/bin/"*; do
        wrapProgram "$prog" \
            --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
            --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
            --prefix PATH : "${mtools}/bin:${cdrkit}/bin:${libcdio}/bin"
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
