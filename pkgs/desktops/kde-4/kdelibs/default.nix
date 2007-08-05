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
  name = "kdelibs-3.91.0";
  
  src = fetchurl {
    url = http://ftp.scarlet.be/pub/kde/stable/3.91.0/src/kdelibs-3.91.0.tar.bz2;
    sha256 = "14zi2wd1k116dvg996cfw53sihm0y7wcqpdxhc4y458mcrb2a8sz";
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
