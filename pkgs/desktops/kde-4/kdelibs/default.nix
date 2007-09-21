{ stdenv, fetchurl
, inputproto, kbproto, scrnsaverproto, xextproto, xf86miscproto
, xf86vidmodeproto, xineramaproto, xproto
, libICE
, libX11
, libXau
, libXcomposite
, libXcursor
, libXdamage
, libXdmcp
, libXext
, libXfixes
, libXft
, libXi
, libXpm
, libXrandr
, libXrender
, libXScrnSaver
, libXt
, libXtst
, libXv
, libXxf86misc
, libxkbfile
, zlib, perl, qt, openssl, pcre
, pkgconfig, libjpeg, libpng, libtiff, libxml2, libxslt, libtool, expat
, freetype, bzip2, strigi, cmake, shared_mime_info, alsaLib, libungif
, cups
}:

stdenv.mkDerivation {
  name = "kdelibs-4.0beta1";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.92/src/kdelibs-3.92.0.tar.bz2;
    sha256 = "19jd9nx5g0ayxavj3ys52wx5ppxw9yr9jylxk7qplxsm525ryf1p";
  };

  buildInputs = [
	inputproto kbproto scrnsaverproto xextproto xf86miscproto xf86vidmodeproto
	xineramaproto xproto libICE libX11 libXau libXcomposite libXcursor
	libXdamage libXdmcp libXext libXfixes libXft libXi libXpm libXrandr
	libXrender libXScrnSaver libXt libXtst libXv libXxf86misc libxkbfile
    zlib perl qt openssl pcre 
    pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2 strigi cmake shared_mime_info alsaLib libungif cups
  ];
  patchPhase = "sed -e 's@ NO_SYSTEM_PATH@@g' -i ../cmake/modules/FindX11.cmake";
}
