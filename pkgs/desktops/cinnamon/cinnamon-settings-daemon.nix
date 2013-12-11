 
{stdenv, fetchurl, pkgconfig, autoreconfHook, glib, gettext, gnome_common, makeWrapper,
cinnamon-desktop, systemd, intltool, gtk3, libnotify, lcms2, libxkbfile, ibus, pulseaudio,
libcanberra, upower, libcanberra_gtk3, colord, libxslt, docbook_xsl }:

let
  version = "2.0.8";
in
stdenv.mkDerivation {
  name = "cinnamon-settings-deamon-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-settings-daemon/archive/${version}.tar.gz";
    sha256 = "1zbpr2a7qyh3jzvaa7if4dh258c319aams4gqx3d34xbmhhz12b8";
  };


  configureFlags = "-enable-systemd --disable-static" ;

  patches = [ ./keyboard.patch ./automount-plugin.patch];

  buildInputs = [
    pkgconfig autoreconfHook
    glib gettext gnome_common
    systemd makeWrapper intltool
    gtk3 cinnamon-desktop libnotify
    lcms2 ibus libxkbfile pulseaudio libcanberra
    upower libcanberra_gtk3 colord
    libxslt docbook_xsl
   ];

  preBuild = "patchShebangs ./scripts";


  postInstall  = ''
    ${glib}/bin/glib-compile-schemas $out/share/glib-2.0/schemas/
   
   for f in "$out"/bin/*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$out/share:${cinnamon-desktop}/share"
    done
  '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "The cinnamon settings daemon" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}

