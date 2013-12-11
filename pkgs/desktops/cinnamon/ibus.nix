 
{ stdenv, fetchurl, makeWrapper, cinnamon-desktop, python , glib, intltool, pkgconfig,
gtk2, gtk3, dbus, dconf, GConf, libnotify, isocodes, gobjectIntrospection }:

let
  version = "1.5.4";
in
stdenv.mkDerivation rec {
  name = "ibus-${version}";

  src = fetchurl {
    url = "http://ibus.googlecode.com/files/${name}.tar.gz";
    sha256 = "1z8ls9jdxk131lnphyfv9vdwrldrhlfiddlz2634md817yxblgkh";
  };


  configureFlags = "--disable-gconf --enable-dconf --disable-memconf --enable-ui --enable-python-library" ;

  buildInputs = [
    makeWrapper python glib
    intltool pkgconfig gtk2
    gtk3 dbus dconf GConf
    libnotify isocodes gobjectIntrospection
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
    description = "The cinnamon session files" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}

