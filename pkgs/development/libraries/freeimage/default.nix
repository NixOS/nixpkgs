{ lib, stdenv, dos2unix, fetchurl, unzip, darwin, patchutils }:

let
  patchVersion = "1.6.37";

  patch_apng = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    sha256 = "1dh0250mw9b2hx7cdmnb2blk7ddl49n6vx8zz7jdmiwxy38v4fw2"; # patch.gz
  };
  arm_patch_src = fetchurl {
    url = "mirror://sourceforge/apng/libpng-${patchVersion}-apng.patch.gz";
    sha256 = "0g38frllvg6a2x2g0b6irgc2xvhbgi9bfpimkfkqgcz2c35y1n8h";
  };
in
stdenv.mkDerivation {
  name = "freeimage-3.18.0";

  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3180.zip;
    sha256 = "1z9qwi9mlq69d5jipr3v2jika2g0kszqdzilggm99nls5xl7j4zl";
  };

  patches = lib.optional stdenv.isDarwin ./dylib.patch;

  buildInputs = [ unzip dos2unix ] ++ lib.optional stdenv.isDarwin darwin.cctools;

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
  '' + ''
    (
      cd ./Source/LibPNG
      find . -type f -print0 | xargs -0 dos2unix
      gunzip < ${patch_apng} >patch
      cat ${patch_arm} >patch3
      ${patchutils}/bin/filterdiff -p1 --exclude '*scripts/*' > patch2
      patch -Np1 <patch2
      patch -Np1 <patch3
    )
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

