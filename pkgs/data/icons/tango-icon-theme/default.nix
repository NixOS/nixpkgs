{ stdenv, fetchurl, intltool, pkgconfig, iconnamingutils, imagemagick, librsvg
, gtk/*any version*/
}:

stdenv.mkDerivation rec {
  name = "tango-icon-theme-0.8.90";

  src = fetchurl {
    url = "http://tango.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "13n8cpml71w6zfm2jz5fa7r1z18qlzk4gv07r6n1in2p5l1xi63f";
  };

  patches = [ ./rsvg-convert.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool iconnamingutils imagemagick librsvg ];

  configureFlags = [ "--enable-png-creation" ];

  postInstall = '''${gtk.out}/bin/gtk-update-icon-cache' "$out/share/icons/Tango" '';

  meta = {
    description = "A basic set of icons";
    homepage = http://tango.freedesktop.org/Tango_Icon_Library;
    platforms = stdenv.lib.platforms.linux;
  };
}
