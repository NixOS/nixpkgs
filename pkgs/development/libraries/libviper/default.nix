{stdenv, fetchurl, pkgconfig, glib, ncurses, gpm}:
stdenv.mkDerivation rec {
  name = "libviper-1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/libviper/${name}.tar.gz";
    sha256 = "1jvm7wdgw6ixyhl0pcfr9lnr9g6sg6whyrs9ihjiz0agvqrgvxwc";
  };

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ -e /ldconfig/d -e '/cd vdk/d' Makefile
  '';

  preInstall = ''
    mkdir -p $out/include
    mkdir -p $out/lib
  '';

  buildInputs = [pkgconfig glib ncurses gpm];

  meta = with stdenv.lib; {
    homepage = http://libviper.sourceforge.net/;
    description = "Simple window creation and management facilities for the console";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
