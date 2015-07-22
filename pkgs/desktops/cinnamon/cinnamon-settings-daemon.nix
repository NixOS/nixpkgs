
{ stdenv, fetchurl, pkgconfig, autoreconfHook, glib, gettext, gnome_common, cinnamon-desktop, intltool, gtk3,
libnotify, lcms2, libxklavier, libgnomekbd, libcanberra, libpulseaudio, upower, libcanberra_gtk3, colord,
systemd, libxslt, docbook_xsl, makeWrapper, gsettings_desktop_schemas}:

let
  version = "2.0.10";
in
stdenv.mkDerivation {
  name = "cinnamon-settings-daemon-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-settings-daemon/archive/${version}.tar.gz";
    sha256 = "10r75xsngb7ipv9fy07dyfb256bqybzcxbwny60sgjhrksk3v9mg";
  };

  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  configureFlags = "--enable-systemd" ;

  patches = [ ./systemd-support.patch ./automount-plugin.patch ./dpms.patch];

  buildInputs = [
    pkgconfig autoreconfHook
    glib gettext gnome_common
    intltool gtk3 libnotify lcms2
    libgnomekbd libxklavier colord
    libcanberra libpulseaudio upower
    libcanberra_gtk3 cinnamon-desktop
    systemd libxslt docbook_xsl makeWrapper
    gsettings_desktop_schemas
   ];

  preBuild = "patchShebangs ./scripts";

  #ToDo: missing org.cinnamon.gschema.xml, probably not packaged yet
  postFixup  = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';


  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "The cinnamon session files" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];

    broken = true;
  };
}
