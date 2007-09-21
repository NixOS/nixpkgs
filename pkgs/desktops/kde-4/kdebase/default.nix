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
, libXinerama
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
, libusb, glib, mesa
, cups, kdelibs, kdepimlibs
}:

stdenv.mkDerivation {
  name = "kdebase-4.0beta1";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://kde/unstable/3.92/src/kdebase-3.92.0.tar.bz2;
    sha256 = "1xh5a93l6anmix358fll4xfqm5fl4hpm1ksmlab8hr8s7vqng707";
  };

  buildInputs = [
	inputproto kbproto scrnsaverproto xextproto xf86miscproto xf86vidmodeproto
	xineramaproto xproto libICE libX11 libXau libXcomposite libXcursor
	libXdamage libXdmcp libXext libXfixes libXft libXi libXpm libXrandr
	libXinerama mesa stdenv.gcc.libc
	libXrender libXScrnSaver libXt libXtst libXv libXxf86misc libxkbfile
    zlib perl qt openssl pcre 
    pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2 strigi cmake shared_mime_info alsaLib libungif cups
	kdelibs kdepimlibs libusb glib
  ];
# TODO : it should be done through setup-hooks
  KDEDIRS="${kdelibs}/share/apps:${kdepimlibs}/share/apps";
  inherit qt kdelibs;
}
