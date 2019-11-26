
{ stdenv, fetchurl, pkgconfig, autoreconfHook, glib, gettext, gnome_common, gtk3,intltool,
cinnamon-desktop, clutter, cogl, zenity, python, gnome_doc_utils, makeWrapper}:

let
  version = "2.0.5";
in
stdenv.mkDerivation {
  name = "muffin-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/muffin/archive/${version}.tar.gz";
    sha256 = "1vn7shxwyxsa6dd3zldrnc0095i1y0rq0944n8kak3m85r2pv9c1";
  };


  configureFlags = "--enable-compile-warnings=minium" ;

  patches = [./gtkdoc.patch];

  buildInputs = [
    pkgconfig autoreconfHook
    glib gettext gnome_common
    gtk3 intltool cinnamon-desktop
    clutter cogl zenity python
    gnome_doc_utils makeWrapper];

  preBuild = "patchShebangs ./scripts";


  postFixup  = ''

    for f in "$out/bin/"*; do
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
