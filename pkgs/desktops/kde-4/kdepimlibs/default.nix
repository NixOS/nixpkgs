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
, cups, kdelibs, boost, gpgme
}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.0beta1";
  
  src = fetchurl {
    url = http://ftp.scarlet.be/pub/kde/unstable/3.92/src/kdepimlibs-3.92.0.tar.bz2;
    sha256 = "0q7zzj8n282xaxvdij74fb17w5c1vja7izxfrkcbq7arn9f40wbx";
  };

  buildInputs = [
	inputproto kbproto scrnsaverproto xextproto xf86miscproto xf86vidmodeproto
	xineramaproto xproto libICE libX11 libXau libXcomposite libXcursor
	libXdamage libXdmcp libXext libXfixes libXft libXi libXpm libXrandr
	libXrender libXScrnSaver libXt libXtst libXv libXxf86misc libxkbfile
    zlib perl qt openssl pcre 
    pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2 strigi cmake shared_mime_info alsaLib libungif cups
	kdelibs boost gpgme
  ];
}
