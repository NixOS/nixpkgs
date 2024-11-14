{ lib
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kdecoration
, plasma-workspace
, qtbase
}:

stdenv.mkDerivation {
  pname = "breath-theme";
  version = "unstable-2022-12-22";

  src = fetchFromGitLab {
    domain = "gitlab.manjaro.org";
    owner = "themes";
    group = "artwork";
    repo = "breath";
    rev = "98822e7d903f16116bfb02ff9921824c139d7bbc";
    sha256 = "sha256-gvzhHOuOhxV3TC3UZeVpxeSDLpCJV+SaapcJ5mbHskY=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules

    kdecoration
    plasma-workspace
    qtbase
  ];

  dontWrapQtApps = true;

  cmakeFlags = [ "-DBUILD_PLASMA_THEMES=ON" "-DBUILD_SDDM_THEME=ON" ];

  meta = with lib; {
    description = "Manjaro KDE default theme";
    homepage = "https://gitlab.manjaro.org/artwork/themes/breath";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ huantian ];
    platforms = platforms.linux;
  };
}
