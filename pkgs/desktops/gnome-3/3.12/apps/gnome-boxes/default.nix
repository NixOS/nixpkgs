{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, itstool, libvirt-glib
, glib, gobjectIntrospection, libxml2, gtk3, gtkvnc, libvirt, spice_gtk
, spice_protocol, libuuid, libsoup, libosinfo, systemd, tracker, vala
, libcap_ng, libcap, yajl, gmp, gdbm, cyrus_sasl, gnome3, librsvg
, hicolor_icon_theme, desktop_file_utils, mtools, cdrkit, libcdio
}:

# TODO: ovirt (optional)

stdenv.mkDerivation rec {
  name = "gnome-boxes-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-boxes/3.12/${name}.tar.xz";
    sha256 = "0kzdh8kk9isaskbfyj7r7nybgdyhj7i4idkgahdsl9xs9sj2pmc8";
  };

  enableParallelBuilding = true;

  doCheck = true;

  buildInputs = [
    makeWrapper pkgconfig intltool itstool libvirt-glib glib
    gobjectIntrospection libxml2 gtk3 gtkvnc libvirt spice_gtk spice_protocol
    libuuid libsoup libosinfo systemd tracker vala libcap_ng libcap yajl gmp
    gdbm cyrus_sasl gnome3.gnome_icon_theme gnome3.gnome_icon_theme_symbolic
    librsvg hicolor_icon_theme desktop_file_utils
  ];

  preFixup = ''
    for prog in "$out/bin/"*; do
        wrapProgram "$prog" \
            --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
            --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
            --prefix PATH : "${mtools}/bin:${cdrkit}/bin:${libcdio}/bin"
    done
    rm "$out/share/icons/hicolor/icon-theme.cache"
  '';

  meta = with stdenv.lib; {
    description = "Simple GNOME 3 application to access remote or virtual systems";
    homepage = https://wiki.gnome.org/action/show/Apps/Boxes;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
