{stdenv, fetchurl, unzip}:
stdenv.mkDerivation {
  name = "freeimage-3.15.0";
  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3150.zip;
    sha256 = "0diyj862sdqwjqb7v2nccf8cl6886v937jkw6dgszp86qpwsfx3n";
  };
  buildInputs = [ unzip ];
  prePatch = ''
      sed -e s@/usr/@$out/@ \
        -e 's@-o root -g root@@' \
        -e 's@ldconfig@echo not running ldconfig@' \
        -i Makefile.gnu
  '';
  preInstall = "mkdir -p $out/include $out/lib";

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = http://freeimage.sourceforge.net/;
    license = "GPL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
