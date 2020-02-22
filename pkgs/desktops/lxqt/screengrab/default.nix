{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, libqtxdg, xorg, autoPatchelfHook }:

mkDerivation rec {
  pname = "screengrab";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1syvdqq45dr8hwigl9ax1wxr33m8z23nh6xzzlqbflyyd93xzjmn";
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

  meta = with lib; {
    description = "Crossplatform tool for fast making screenshots";
    homepage = "https://github.com/lxqt/screengrab";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
