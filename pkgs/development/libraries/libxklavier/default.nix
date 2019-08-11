{ stdenv, fetchgit, autoreconfHook, pkgconfig, gtk-doc, xkeyboard_config, libxml2, xorg, docbook_xsl
, glib, isocodes, gobject-introspection }:

let
  version = "5.4";
in
stdenv.mkDerivation rec {
  name = "libxklavier-${version}";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/git/libxklavier";
    rev = name;
    sha256 = "1w1x5mrgly2ldiw3q2r6y620zgd89gk7n90ja46775lhaswxzv7a";
  };

  outputs = [ "out" "dev" "devdoc" ];

  # TODO: enable xmodmap support, needs xmodmap DB
  propagatedBuildInputs = with xorg; [ libX11 libXi xkeyboard_config libxml2 libICE glib libxkbfile isocodes ];

  nativeBuildInputs = [ autoreconfHook pkgconfig gtk-doc docbook_xsl ];

  buildInputs = [ gobject-introspection ];

  preAutoreconf = ''
    export NOCONFIGURE=1
    gtkdocize
  '';

  configureFlags = [
    "--with-xkb-base=${xkeyboard_config}/etc/X11/xkb"
    "--with-xkb-bin-base=${xorg.xkbcomp}/bin"
    "--disable-xmodmap-support"
    "--enable-gtk-doc"
  ];

  meta = with stdenv.lib; {
    description = "Library providing high-level API for X Keyboard Extension known as XKB";
    homepage = http://freedesktop.org/wiki/Software/LibXklavier;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
