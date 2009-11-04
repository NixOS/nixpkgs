{stdenv, fetchurl, pkgconfig, glib, ncurses, gpm}:
stdenv.mkDerivation rec {
  name = "libviper-1.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/libviper/${name}.tar.gz";
    sha256 = "1lryqv9xfsshx8x8c858h8fmsi2fkja0mhw415wa2bj9cqyb8byz";
  };

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ -e /ldconfig/d -e '/cd vdk/d' Makefile
  '';

  preInstall = ''
    ensureDir $out/include
    ensureDir $out/lib
  '';

  buildInputs = [pkgconfig glib ncurses gpm];

  meta = {
    homepage = http://libviper.sourceforge.net/;
    description = "Simple window creation and management facilities for the console";
    license="GPLv2+";
  };
}
