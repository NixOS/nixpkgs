{stdenv, fetchurl, unzip}:
stdenv.mkDerivation {
  name = "freeimage-3.13.0";
  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3130.zip;
    sha256 = "0hf642cb1bai1j4izvjnmili9ic335awa4jnn6nxa0bv6wfaa9x2";
  };
  buildInputs = [ unzip ];
  patchPhase = ''
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
