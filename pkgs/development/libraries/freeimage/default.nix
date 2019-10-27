{ lib, stdenv, fetchurl, unzip, darwin }:

stdenv.mkDerivation {
  name = "freeimage-3.18.0";

  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3180.zip;
    sha256 = "1z9qwi9mlq69d5jipr3v2jika2g0kszqdzilggm99nls5xl7j4zl";
  };

  patches = lib.optional stdenv.isDarwin ./dylib.patch;

  buildInputs = [ unzip ] ++ lib.optional stdenv.isDarwin darwin.cctools;

  prePatch = if stdenv.isDarwin then ''
    sed -e 's/$(shell xcrun -find clang)/clang/g' \
        -e 's/$(shell xcrun -find clang++)/clang++/g' \
        -e "s|PREFIX = /usr/local|PREFIX = $out|" \
        -e 's|-Wl,-syslibroot $(MACOSX_SYSROOT)||g' \
        -e 's|-isysroot $(MACOSX_SYSROOT)||g' \
        -e 's|	install -d -m 755 -o root -g wheel $(INCDIR) $(INSTALLDIR)||' \
        -e 's| -m 644 -o root -g wheel||g' \
        -i ./Makefile.osx
    # Fix LibJXR performance timers
    sed 's|^SRCS = \(.*\)$|SRCS = \1 Source/LibJXR/image/sys/perfTimerANSI.c|' -i ./Makefile.srcs
  '' else ''
    sed -e s@/usr/@$out/@ \
        -e 's@-o root -g root@@' \
        -e 's@ldconfig@echo not running ldconfig@' \
        -i Makefile.gnu Makefile.fip
  '';

  postBuild = lib.optionalString (!stdenv.isDarwin) ''
    make -f Makefile.fip
  '';

  preInstall = ''
    mkdir -p $out/include $out/lib
  '';

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    make -f Makefile.fip install
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = http://freeimage.sourceforge.net/;
    license = "GPL";
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; unix;
  };
}
