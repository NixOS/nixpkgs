{ stdenv, fetchpatch, fetchurl, unzip, darwin }:

stdenv.mkDerivation {
  name = "freeimage-3.17.0";

  src = fetchurl {
    url = mirror://sourceforge/freeimage/FreeImage3170.zip;
    sha256 = "12bz57asdcfsz3zr9i9nska0fb6h3z2aizy412qjqkixkginbz7v";
  };

  patches = [
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/debian-science/packages/freeimage.git/plain/debian/patches/Fix-CVE-2015-0852.patch";
      sha256 = "0qkb96mvvhji75gz7dma3vj2b71smp96z3kl2ydj6skvnw6slnmc";
    })
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/debian-science/packages/freeimage.git/plain/debian/patches/Fix-CVE-2016-5684.patch";
      sha256 = "18g5ckrvqfjcldis7zf7hmfl8b3mgnc6akd6x3cdq8c5j7l1y98f";
    })
  ];

  buildInputs = [ unzip ] ++ stdenv.lib.optional stdenv.isDarwin darwin.cctools;

  prePatch = if stdenv.isDarwin
             then ''
    sed -e 's/gcc-4.0/clang/g' \
        -e 's/g++-4.0/clang++/g' \
        -e 's/COMPILERFLAGS = -Os -fexceptions -fvisibility=hidden -DNO_LCMS/COMPILERFLAGS = -Os -fexceptions -fvisibility=hidden -DNO_LCMS -D__ANSI__/' \
        -e "s|PREFIX = /usr/local|PREFIX = $out|" \
        -e 's|-Wl,-syslibroot /Developer/SDKs/MacOSX10.5.sdk||g' \
        -e 's|-Wl,-syslibroot /Developer/SDKs/MacOSX10.6.sdk||g' \
        -e 's|-isysroot /Developer/SDKs/MacOSX10.6.sdk||g' \
        -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||g' \
        -e 's| $(STATICLIB)-ppc $(STATICLIB)-i386||g' \
        -e 's| $(SHAREDLIB)-ppc $(SHAREDLIB)-i386||g' \
        -e 's|	install -d -m 755 -o root -g wheel $(INCDIR) $(INSTALLDIR)||' \
        -e 's| -m 644 -o root -g wheel||g' \
        -i ./Makefile.osx
    # Fix LibJXR performance timers
    sed 's|^SRCS = \(.*\)$|SRCS = \1 Source/LibJXR/image/sys/perfTimerANSI.c|' -i ./Makefile.srcs
  ''
             else ''
    sed -e s@/usr/@$out/@ \
        -e 's@-o root -g root@@' \
        -e 's@ldconfig@echo not running ldconfig@' \
        -i Makefile.gnu Makefile.fip
    # Fix gcc 5.1 macro problems
    # https://chromium.googlesource.com/webm/libwebp/+/eebaf97f5a1cb713d81d311308d8a48c124e5aef%5E!/
    sed -i -e 's/"\(#[^"]*\)"/" \1 "/g' Source/LibWebP/src/dsp/*
  '';

  postBuild = stdenv.lib.optionalString (!stdenv.isDarwin) "make -f Makefile.fip";
  preInstall = "mkdir -p $out/include $out/lib";
  postInstall = stdenv.lib.optionalString (!stdenv.isDarwin) "make -f Makefile.fip install";

  NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = http://freeimage.sourceforge.net/;
    license = "GPL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; unix;
  };
}
