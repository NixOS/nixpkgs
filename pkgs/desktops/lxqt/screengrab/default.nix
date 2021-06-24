{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qttools
, qtx11extras
, qtsvg
, kwindowsystem
, libqtxdg
, perl
, xorg
, autoPatchelfHook
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "screengrab";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "16dycq40lbvk6jvpj7zp85m23cgvh8nj38fz99gxjfzn2nz1gy4a";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl # needed by LXQtTranslateDesktop.cmake
    autoPatchelfHook # fix libuploader.so and libextedit.so not found
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    kwindowsystem
    libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/screengrab";
    description = "Crossplatform tool for fast making screenshots";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
