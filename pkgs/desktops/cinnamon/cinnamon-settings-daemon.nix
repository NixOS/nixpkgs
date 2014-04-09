 
{ stdenv, fetchurl, pkgconfig, autoreconfHook, glib, gettext, gnome_common, cinnamon-desktop, intltool, gtk3, 
libnotify, lcms2, libxklavier, gnome3}:

let
  version = "2.0.10";
in
stdenv.mkDerivation {
  name = "cinnamon-settings-daemon-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-settings-daemon/archive/${version}.tar.gz";
    sha256 = "10r75xsngb7ipv9fy07dyfb256bqybzcxbwny60sgjhrksk3v9mg";
  };


  configureFlags = "--enable-systemd" ;

  patches = [ ./systemd-support.patch ./automount-plugin.patch ./dpms.patch];

  buildInputs = [
    pkgconfig autoreconfHook
    glib gettext gnome_common
    intltool gtk3 libnotify lcms2
    gnome3.libgnomekbd libxklavier
    cinnamon-desktop/*gschemas*/
   
   ];

  preBuild = "patchShebangs ./scripts";


  postFixup  = ''
    rm $out/share/icons/hicolor/icon-theme.cache

    for f in "$out"/bin/*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "The cinnamon session files" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}

