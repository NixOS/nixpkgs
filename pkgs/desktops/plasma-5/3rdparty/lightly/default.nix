{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, kdecoration
, kcoreaddons
, kguiaddons
, kconfigwidgets
, kwindowsystem
, kiconthemes
, qtx11extras
}:

mkDerivation rec{
  pname = "lightly";
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "Luwx";
    repo = pname;
    rev = "v${version}";
    sha256 = "k1fEZbhzluNlAmj5s/O9X20aCVQxlWQm/Iw/euX7cmI=";
  };

  extraCmakeFlags = [ "-DBUILD_TESTING=OFF" ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [
    kcoreaddons
    kguiaddons
    kconfigwidgets
    kwindowsystem
    kiconthemes
    qtx11extras
    kdecoration
  ];

  meta = with lib; {
    description = "A modern style for qt applications";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pasqui23 ];
    homepage = "https://github.com/Luwx/Lightly/";
    inherit (kwindowsystem.meta) platforms;
  };
}
