{ stdenv, fetchFromGitHub, cmake, extra-cmake-modules, pkgconfig
, qtbase, qtimageformats, qtwebkit, qtx11extras, mkDerivation
, libarchive, libXdmcp, libpthreadstubs, xcbutilkeysyms  }:

mkDerivation rec {
  pname = "zeal";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner  = "zealdocs";
    repo   = "zeal";
    rev    = "v${version}";
    sha256 = "05qcjpibakv4ibhxgl5ajbkby3w7bkxsv3nfv2a0kppi1z0f8n8v";
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
