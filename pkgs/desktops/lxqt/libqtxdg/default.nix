{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtsvg
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "libqtxdg";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0wiannhaydnbqd8ni3nflx2s4036grxs8aklcb95j88v3cgr2gck";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qtsvg
  ];

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DQTXDGX_ICONENGINEPLUGIN_INSTALL_PATH=$out/$qtPluginPrefix/iconengines"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-DCMAKE_INSTALL_LIBDIR=lib"
    )
  '';

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Qt implementation of freedesktop.org xdg specs";
    homepage = "https://github.com/lxqt/libqtxdg";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
