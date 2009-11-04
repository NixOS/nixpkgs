{stdenv, fetchurl, pkgconfig, glib, ncurses}:
stdenv.mkDerivation rec {
  name = "libvterm-0.99.7";

  src = fetchurl {
    url = "mirror://sourceforge/libvterm/${name}.tar.gz";
    sha256 = "10gaqygmmwp0cwk3j8qflri5caf8vl3f7pwfl2svw5whv8wkn0k2";
  };

  patchPhase = ''
    sed -i -e s@/usr@$out@ -e /ldconfig/d Makefile
  '';

  preInstall = ''
    ensureDir $out/include
    ensureDir $out/lib
  '';

  buildInputs = [pkgconfig glib ncurses];

  meta = {
    homepage = http://libvterm.sourceforge.net/;
    description = "Terminal emulator library to mimic both vt100 and rxvt";
    license="GPLv2+";
  };
}
