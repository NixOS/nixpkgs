args:
rec {
	qca = (import ./qca.nix) args;
	akode = (import ./akode.nix) args;
	gmm = (import ./gmm.nix) args;
	eigen = (import ./eigen.nix) args;
	taglib = (import ./taglib.nix) args;
	soprano = (import ./soprano.nix) args;
	strigi = (import ./strigi.nix) args;
	qimageblitz = (import ./qimageblitz.nix) args;
	all = [qca gmm eigen taglib soprano strigi qimageblitz];
}
#args: with args;
#
#stdenv.mkDerivation {
#  name = "kdesupport-4.0svn-r729462";
#  
#  src = fetchsvn {
#    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport;
#	rev = 729462;
#	md5 = "aa50ec8e5c8d49e1dfd53143345cb4b3";
#  };
#
#  propagatedBuildInputs = [
#	exiv2
#	cmake inputproto kbproto scrnsaverproto xextproto xf86miscproto xf86vidmodeproto
#	xineramaproto xproto libICE libX11 libXau libXcomposite libXcursor
#	libXdamage libXdmcp libXext libXfixes libXft libXi libXpm libXrandr
#	libXrender libXScrnSaver libXt libXtst libXv libXxf86misc libxkbfile zlib
#	perl qt openssl pcre pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
#    libtool freetype bzip2 shared_mime_info alsaLib libungif cups
#	gettext cluceneCore redland stdenv.gcc.libc dbus bison cppunit
#  ];
#  CLUCENE_HOME=cluceneCore;
#  patchPhase = "sed -e '/set(qca_PLUGINSDIR/s@\${QT_PLUGINS_DIR}@\${CMAKE_INSTALL_PREFIX}/plugins@' -i ../qca/CMakeLists.txt";
#}
