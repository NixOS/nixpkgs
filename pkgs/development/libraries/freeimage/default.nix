{stdenv, fetchurl, unzip}:
stdenv.mkDerivation {
  name = "freeimage-3.14.1";
  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3141.zip;
    sha256 = "0rgzdjwzd64z5z9j4bq075h3kfqjk8ab2dwswy0lnzw9jvmbbifm";
  };
  buildInputs = [ unzip ];
  prePatch = ''
      sed -e s@/usr/@$out/@ \
        -e 's@-o root -g root@@' \
        -e 's@ldconfig@echo not running ldconfig@' \
        -i Makefile.gnu
  '';
  patches = [ ./memset.patch ];
  preInstall = "mkdir -p $out/include $out/lib";

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = http://freeimage.sourceforge.net/;
    license = "GPL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
