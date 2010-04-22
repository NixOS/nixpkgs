{stdenv, fetchurl, unzip}:
stdenv.mkDerivation {
  name = "freeimage-3.13.1";
  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3131.zip;
    sha256 = "1ilpfgyi3qhjra5hxvjcrq3bna909bgdl7rgmhkybmcpdq1x56rj";
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
