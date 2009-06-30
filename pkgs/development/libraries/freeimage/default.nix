{stdenv, fetchurl, unzip}:
stdenv.mkDerivation {
  name = "freeimage-3.12.0";
  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3120.zip;
    sha256 = "1hvcmv8hnv3h24zcl324g3l0ww8aa8fkcfav2lrgs1kwzp5zqcd4";
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
