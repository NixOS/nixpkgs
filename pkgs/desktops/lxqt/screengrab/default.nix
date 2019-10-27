{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, libqtxdg, xorg, autoPatchelfHook }:

mkDerivation rec {
  pname = "screengrab";
  version = "1.101";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "111gnkhp77qkch7xqr7k3h8zrg4871gapyd4vvlpaj0gjhirjg6h";
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
    homepage = https://github.com/lxqt/screengrab;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
