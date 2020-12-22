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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0jy2izgl3jg6mnykpw7ji1fjv7dsivdfi6k6i6glrpa0z1p51gic";
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
