{ stdenv, intltool, fetchurl, apacheHttpd_2_2, nautilus
, pkgconfig, gtk3, glib, libxml2, gnused
, bash, makeWrapper, itstool, libnotify, libtool, mod_dnssd
, gnome3, librsvg, gdk_pixbuf, file, libcanberra_gtk3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' -i data/dav_user_2.2.conf 
  '';

  configureFlags = [ "--with-httpd=${apacheHttpd_2_2.out}/bin/httpd"
                     "--with-modules-path=${apacheHttpd_2_2.dev}/modules"
                     "--disable-bluetooth"
                     "--with-nautilusdir=$(out)/lib/nautilus/extensions-3.0" ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 libtool
                  makeWrapper file gdk_pixbuf gnome3.defaultIconTheme librsvg
                  nautilus libnotify libcanberra_gtk3 ];

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/$name
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/$name
    ${glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas
  '';

  preFixup = ''
    wrapProgram "$out/libexec/gnome-user-share-webdav" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-user-share/3.8;
    description = "Service that exports the contents of the Public folder in your home directory on the local network";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
