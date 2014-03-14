 
{ stdenv, fetchurl, makeWrapper, cinnamon-desktop, glib, libxslt, vala, pkgconfig,
dbus, gtk3, libxml2, intltool, docbook_xsl}:

let
  version = "0.18.0";
in
stdenv.mkDerivation rec {
  name = "dconf-${version}";

  src = fetchurl {
    url = "http://download.gnome.org/sources/dconf/0.18/${name}.tar.xz";
    sha256 = "109b1bc6078690af1ed88cb144ef5c5aee7304769d8bdc82ed48c3696f10c955";
  };


  buildInputs = [
    makeWrapper libxslt vala
    pkgconfig glib dbus gtk3
    libxml2 intltool docbook_xsl
    ];

  preBuild = "patchShebangs ./scripts";


  postInstall  = ''
    ${glib}/bin/glib-compile-schemas $out/share/glib-2.0/schemas/
    rm $out/share/icons/hicolor/icon-theme.cache

    for f in "$out"/bin/*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$out/share:${cinnamon-desktop}/share"
    done
  '';

  meta = {
    homepage = "http://live.gnome.org/dconf";
    description = "A low level configuration system" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}

