{ lib, stdenv, fetchurl, pkg-config, glib, ncurses }:

stdenv.mkDerivation rec {
  pname = "libvterm";
  version = "0.99.7";

  src = fetchurl {
    url = "mirror://sourceforge/libvterm/${pname}-${version}.tar.gz";
    sha256 = "10gaqygmmwp0cwk3j8qflri5caf8vl3f7pwfl2svw5whv8wkn0k2";
  };

  patchPhase = ''
    sed -i -e s@/usr@$out@ -e /ldconfig/d Makefile
  '';

  preInstall = ''
    mkdir -p $out/include
    mkdir -p $out/lib
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib ncurses ];

  meta = with lib; {
    homepage = "http://libvterm.sourceforge.net/";
    description = "Terminal emulator library to mimic both vt100 and rxvt";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
