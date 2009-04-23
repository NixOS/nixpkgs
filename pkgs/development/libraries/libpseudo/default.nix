{stdenv, fetchurl, pkgconfig, glib, ncurses}:
stdenv.mkDerivation {
  name = "libpseudo-1.1.0";

  src = fetchurl {
    url = mirror://sourceforge/libpseudo/libpseudo-1.1.0.tar.gz;
    sha256 = "0fp64c6sbdrp4gs4a7rnh5zwis73p7zg04basdn91byshvs1giwv";
  };

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ -e /ldconfig/d Makefile
  '';

  preInstall = ''
    ensureDir $out/include
    ensureDir $out/lib
  '';

  buildInputs = [pkgconfig glib ncurses];

  meta = {
    homepage = http://libpseudo.sourceforge.net/;
    description = "Simple, thread-safe messaging between threads";
    license="GPLv2+";
  };
}
