{ stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, uthash
, xcbutil
, xcbutilkeysyms
, xorgproto
}:

stdenv.mkDerivation rec {
  pname = "xcb-imdkit";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "xcb-imdkit";
    rev = version;
    sha256 = "dvax+Wj8+tHdiL6txcuugrOlRnxdIW25DYO4iNAYK8M=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    xorgproto
    uthash
  ];

  buildInputs = [
    xcbutil
    xcbutilkeysyms
  ];

  meta = with stdenv.lib; {
    description = "input method development support for xcb";
    homepage = "https://github.com/fcitx/xcb-imdkit";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
