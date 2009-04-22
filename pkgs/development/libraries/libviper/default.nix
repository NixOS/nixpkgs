{stdenv, fetchurl, pkgconfig, glib, ncurses, gpm}:
stdenv.mkDerivation {
  name = "libviper-1.2.2";

  src = fetchurl {
    url = mirror://sourceforge/libviper/libviper-1.4.2.tar.gz;
    sha256 = "06ff9i914cxi3ifnr5xfpfbvz46kx150jaxvr6rcha6ylglw48c9";
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
