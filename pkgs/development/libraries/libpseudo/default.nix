{stdenv, fetchurl, pkgconfig, glib, ncurses}:
stdenv.mkDerivation rec {
  name = "libpseudo-1.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/libpseudo/${name}.tar.gz";
    sha256 = "0d3pw0m3frycr3x5kzqcaj4r2qh43iv6b0fpd6l4yk0aa4a9560n";
  };

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ -e /ldconfig/d Makefile
  '';

  preInstall = ''
    mkdir -p $out/include
    mkdir -p $out/lib
  '';

  buildInputs = [pkgconfig glib ncurses];

  meta = {
    homepage = http://libpseudo.sourceforge.net/;
    description = "Simple, thread-safe messaging between threads";
    license="GPLv2+";
  };
}
