{stdenv, fetchurl, unzip}:
stdenv.mkDerivation {
  name = "freeimage-3.15.3";
  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3153.zip;
    sha256 = "0i60fn1n9rw55dci0yw92zrw7k1jz3f9kv2z1wxmh84s5ngxa626";
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
