{ stdenv, fetchurl, pkgconfig, libtool
, xlibsWrapper, xbitmaps, libXrender, libXmu, libXt
, expat, libjpeg, libpng, libiconv
, flex
, libXp, libXau
, demoSupport ? false, autoconf, automake
}:
# refer to the gentoo package

stdenv.mkDerivation rec {
  name = "motif-${version}";
  version = "2.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/motif/${name}.tar.gz";
    sha256 = "1ksqbp0bzdw6wcrx8s4hj4ivvxmw54hz85l2xfigb87cxmmhx0gs";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [
    pkgconfig libtool
    xlibsWrapper xbitmaps libXrender libXmu libXt
    expat libjpeg libpng libiconv
  ] ++ stdenv.lib.optionals (!demoSupport) [ autoconf automake ];

  nativeBuildInputs = [ flex ];

  propagatedBuildInputs = [ libXp libXau ];

  hardeningDisable = [ "format" ];

  makeFlags = [ "CFLAGS=-fno-strict-aliasing" ];

  patchPhase = ''
    rm lib/Xm/Xm.h
    echo -e '"The X.Org Foundation"\t\t\t\t\tpc' >>bindings/xmbind.alias
  '' + stdenv.lib.optionalString (!demoSupport)
  ''
    sed -i -e '/^SUBDIRS/{:x;/\\$/{N;bx;};s/[ \t\n\\]*demos//;}' Makefile.am
  '';

  meta = with stdenv.lib; {
    homepage = http://motif.ics.com;
    description = "Unix standard widget-toolkit and window-manager";
    platforms = with platforms; linux;
    license = with licenses; [ lgpl21 ];
    maintainers = with maintainers; [ ];
  };
}
