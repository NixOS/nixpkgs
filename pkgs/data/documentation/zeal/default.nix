{ stdenv, fetchFromGitHub, libarchive, pkgconfig, qtbase
, qtimageformats, qtwebkit, qtx11extras, xcbutilkeysyms, qmakeHook }:

stdenv.mkDerivation rec {
  version = "0.3.1";
  name = "zeal-${version}";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "v${version}";
    sha256 = "14ld7zm15677jdlasnfa6c42kiswd4d6yg1db50xbk2yflzzwqqa";
  };

  buildInputs = [
    xcbutilkeysyms pkgconfig qtbase qtimageformats qtwebkit qtx11extras libarchive qmakeHook
  ];

  qmakeFlags = [ "PREFIX=/" ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "A simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (OS X
      app), available for Linux and Windows.
    '';
    homepage = "http://zealdocs.org/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}
