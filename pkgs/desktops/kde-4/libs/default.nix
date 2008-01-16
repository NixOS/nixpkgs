args: with args;

stdenv.mkDerivation rec {
  name = "kdelibs-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdelibs-4.0.0.tar.bz2;
    sha256 = "0bfcrb34kl2md77k9rbr924n5bc7chc5wkr10jjvq98742yh0rza";
  };

  propagatedBuildInputs = [
	inputproto kbproto scrnsaverproto xextproto xf86miscproto xf86vidmodeproto
	xineramaproto xproto libICE libX11 libXau libXcomposite libXcursor
	libXdamage libXdmcp libXext libXfixes libXft libXi libXpm libXrandr
	libXrender libXScrnSaver libXt libXtst libXv libXxf86misc libxkbfile zlib
	perl qt openssl pcre pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2 shared_mime_info alsaLib libungif cups
	gettext enchant openexr aspell stdenv.gcc.libc jasper
  ] ++ kdesupport.all;
  buildInputs = [ cmake ];
  patchPhase = "cp ${findIlmBase} ../cmake/modules/FindIlmBase.cmake;
  cp $findOpenEXR ../cmake/modules/FindOpenEXR.cmake;
  sed -e 's@Soprano/DummyModel@Soprano/Util/DummyModel@' -i ../nepomuk/core/resourcemanager.cpp;";

  findIlmBase = ./FindIlmBase.cmake;
  findOpenEXR = ./FindOpenEXR.cmake;
  setupHook=./setup.sh;
}
