{ lib, stdenv, fetchurl, intltool, pkg-config, iconnamingutils, imagemagick, librsvg
, gtk/*any version*/, gnome-icon-theme, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "tango-icon-theme";
  version = "0.8.90";

  src = fetchurl {
    url = "http://tango.freedesktop.org/releases/tango-icon-theme-${version}.tar.gz";
    sha256 = "13n8cpml71w6zfm2jz5fa7r1z18qlzk4gv07r6n1in2p5l1xi63f";
  };

  patches = [ ./rsvg-convert.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ intltool iconnamingutils imagemagick librsvg ];
  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];
  # still missing parent icon themes: cristalsvg

  dontDropIconThemeCache = true;

  configureFlags = [ "--enable-png-creation" ];

  postInstall = '''${gtk.out}/bin/gtk-update-icon-cache' "$out/share/icons/Tango" '';

  meta = {
    description = "A basic set of icons";
    homepage = "http://tango.freedesktop.org/Tango_Icon_Library";
    platforms = lib.platforms.linux;
  };
}
