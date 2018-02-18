{ stdenv, fetchFromGitHub, cmake, extra-cmake-modules, pkgconfig
, qtbase, qtimageformats, qtwebkit, qtx11extras
, libarchive, libXdmcp, libpthreadstubs, xcbutilkeysyms  }:

stdenv.mkDerivation rec {
  name = "zeal-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "zealdocs";
    repo   = "zeal";
    rev    = "v${version}";
    sha256 = "0zsrb89jz04b8in1d69p7mg001yayyljc47vdlvm48cjbhvxwj0k";
  };

  # while ads can be disabled from the user settings, by default they are not so
  # we patch it out completely instead
  patches = [ ./remove_ads.patch ];

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig ];
  buildInputs = [
    qtbase qtimageformats qtwebkit qtx11extras
    libarchive
    libXdmcp libpthreadstubs xcbutilkeysyms
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (macOS
      app), available for Linux and Windows.
    '';
    homepage    = https://zealdocs.org/;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ skeidel peterhoeg ];
    platforms   = platforms.linux;
  };
}
