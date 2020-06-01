{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, qtbase
, qttools
, qtx11extras
, qtsvg
, kwindowsystem
, libqtxdg
, xorg
, autoPatchelfHook
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "screengrab";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "07wm9q0nkrvmyb12kvh0709qrwizlxgy6i5j2czhb4giljrpr4x6";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
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
    description = "Crossplatform tool for fast making screenshots";
    homepage = "https://github.com/lxqt/screengrab";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
