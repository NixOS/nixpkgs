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
, libusb, glib, mesa, gpgme, boost
, cups, kdelibs, kdepimlibs
}:

stdenv.mkDerivation {
  name = "kdepim-4.0beta1";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ftp.scarlet.be/pub/kde/unstable/3.92/src/kdepim-3.92.0.tar.bz2;
    sha256 = "1wlq1h7j07f24n1mjnv9wbfsxn2vn24qfn5dgn4j4fsl84qha16i";
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
	kdelibs kdepimlibs libusb glib gpgme boost
  ];
# TODO : it should be done through setup-hooks
  KDEDIRS="${kdelibs}/share/apps:${kdepimlibs}/share/apps";
  inherit qt kdelibs;
}
