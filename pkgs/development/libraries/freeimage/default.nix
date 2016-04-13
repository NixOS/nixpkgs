{stdenv, fetchurl, unzip}:
stdenv.mkDerivation {
  name = "freeimage-3.17.0";
  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3170.zip;
    sha256 = "12bz57asdcfsz3zr9i9nska0fb6h3z2aizy412qjqkixkginbz7v";
  };
  buildInputs = [ unzip ];
  prePatch = ''
      sed -e s@/usr/@$out/@ \
        -e 's@-o root -g root@@' \
        -e 's@ldconfig@echo not running ldconfig@' \
        -i Makefile.gnu Makefile.fip

      # Fix gcc 5.1 macro problems
      # https://chromium.googlesource.com/webm/libwebp/+/eebaf97f5a1cb713d81d311308d8a48c124e5aef%5E!/
      sed -i -e 's/"\(#[^"]*\)"/" \1 "/g' Source/LibWebP/src/dsp/*
  '';

  postBuild = "make -f Makefile.fip";
  preInstall = "mkdir -p $out/include $out/lib";
  postInstall = "make -f Makefile.fip install";

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = http://freeimage.sourceforge.net/;
    license = "GPL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
