{ lib, stdenv, fetchurl, fetchpatch, pkg-config, libtool
, xbitmaps, libXext, libXft, libXrender, libXmu, libXt
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
    xbitmaps libXext libXft libXrender libXmu libXt
    expat libjpeg libpng libiconv
  ];

  nativeBuildInputs = [ pkg-config flex ];

  propagatedBuildInputs = [ libXp libXau ];

  prePatch = lib.optionalString (!demoSupport) ''
    sed 's/\<demos\>//' -i Makefile.{am,in}
  '';

  patches = [
    ./Remove-unsupported-weak-refs-on-darwin.patch
    ./Add-X.Org-to-bindings-file.patch
    (fetchpatch rec {
      name = "fix-format-security.patch";
      url = "https://raw.githubusercontent.com/void-linux/void-packages/b9a1110dabb01c052dadc1abae1413bd4afe3652/srcpkgs/motif/patches/02-${name}";
      sha256 = "13vzpf8yxvhf4gl7q0yzlr6ak1yzx382fsqsrv5lc8jbbg4nwrrq";
    })
    (fetchpatch {
      name = "missing-headers.patch";
      url = "https://gitlab.freedesktop.org/xorg/lib/libxpm/-/commit/4cedf181bcfe13e5d206554c51edb82cb17e7ad5.patch";
      extraPrefix = "lib/Xm/";
      stripLen = 2;
      hash = "sha256-WlagHOgf2gZDxXN+SSEW6de1FuN4fbpd9zviMwo1+HI=";
    })
    (fetchurl {
      name = "noreturn.patch";
      url = "https://dev.gentoo.org/~ulm/distfiles/motif-2.3.8-patches-5.tar.xz";
      downloadToTemp = true;
      postFetch = ''
        tar -xOf $downloadedFile patch/12_all_noreturn.patch > $out
      '';
      hash = "sha256-FyaBfqD/TuJVFFHZlp1/b1MyL8BJAfV43ktuusgxbfE=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/acc8c7cb2247d9892bf5a52eb92431a4c0c8e1cd/x11/openmotif/files/wcs-functions.patch";
      extraPrefix = "";
      hash = "sha256-w3zCUs/RbnRoUJ0sNCI00noEOkov/IGV/zIygakSQqc=";
    })
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://motif.ics.com";
    description = "Unix standard widget-toolkit and window-manager";
    platforms = platforms.unix;
    license = with licenses; [ lgpl21Plus ];
    maintainers = with maintainers; [ qyliss ];
    broken = demoSupport && stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16";
  };
}
