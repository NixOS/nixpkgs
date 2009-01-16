{stdenv, fetchurl, unzip}:
stdenv.mkDerivation {
  name = "freeimage-3.11.0";
  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3110.zip;
    sha256 = "84021b8c0b86e5801479474ad9a99c18d121508ee16d363e02ddcbf24195340c";
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
  };
}
