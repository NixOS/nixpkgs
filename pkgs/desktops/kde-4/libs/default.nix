args: with args;

stdenv.mkDerivation rec {
  name = "kdelibs-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdelibs-3.95.0.tar.bz2;
    sha256 = "0960880wvwrj68r35knqjjxbqq90xzy1lqv526zyaymp7jc24ybc";
  };

  propagatedBuildInputs = [
	cmake inputproto kbproto scrnsaverproto xextproto xf86miscproto xf86vidmodeproto
	xineramaproto xproto libICE libX11 libXau libXcomposite libXcursor
	libXdamage libXdmcp libXext libXfixes libXft libXi libXpm libXrandr
	libXrender libXScrnSaver libXt libXtst libXv libXxf86misc libxkbfile zlib
	perl qt openssl pcre pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2 shared_mime_info alsaLib libungif cups
	gettext enchant openexr aspell stdenv.gcc.libc
  ] ++ kdesupport.all;
  patchPhase = "cp ${findIlmBase} ../cmake/modules/FindIlmBase.cmake;
  cp $findOpenEXR ../cmake/modules/FindOpenEXR.cmake;
  sed -e 's@Soprano/DummyModel@Soprano/Util/DummyModel@' -i ../nepomuk/core/resourcemanager.cpp;";

  findIlmBase = ./FindIlmBase.cmake;
  findOpenEXR = ./FindOpenEXR.cmake;
  setupHook=./setup.sh;
}
