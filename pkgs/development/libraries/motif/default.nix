{ lib, stdenv, fetchurl, pkg-config, libtool
, xlibsWrapper, xbitmaps, libXrender, libXmu, libXt
, expat, libjpeg, libpng, libiconv
, flex
, libXp, libXau
, demoSupport ? false
}:
# refer to the gentoo package

stdenv.mkDerivation rec {
  pname = "motif";
  version = "2.3.8";

  src = fetchurl {
    url = "mirror://sourceforge/motif/${pname}-${version}.tar.gz";
    sha256 = "1rxwkrhmj8sfg7dwmkhq885valwqbh26d79033q7vb7fcqv756w5";
  };

  buildInputs = [
    libtool
    xlibsWrapper xbitmaps libXrender libXmu libXt
    expat libjpeg libpng libiconv
  ];

  nativeBuildInputs = [ pkg-config flex ];

  propagatedBuildInputs = [ libXp libXau ];

  hardeningDisable = [ "format" ];

  prePatch = lib.optionalString (!demoSupport) ''
    sed '/^SUBDIRS =,^$/s/\<demos\>//' -i Makefile.{am,in}
  '';

  patches = [ ./Remove-unsupported-weak-refs-on-darwin.patch
              ./Add-X.Org-to-bindings-file.patch
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://motif.ics.com";
    description = "Unix standard widget-toolkit and window-manager";
    platforms = platforms.unix;
    license = with licenses; [ lgpl21Plus ];
    maintainers = with maintainers; [ qyliss ];
  };
}
