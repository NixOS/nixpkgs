{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtx11extras
, kcoreaddons
, kguiaddons
, kconfig
, kdecoration
, kconfigwidgets
, kwindowsystem
, kiconthemes
, kwayland
}:

mkDerivation rec {
  pname = "material-kwin-decoration";
  version = "unstable-2021-10-28";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "material-decoration";
    rev = "cc5cc399a546b66907629b28c339693423c894c8";
    sha256 = "sha256-aYlnPFhf+ISVe5Ycryu5BSXY8Lb5OoueMqnWQZiv6Lc=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-Werror" ""
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [
    qtx11extras
    kcoreaddons
    kguiaddons
    kdecoration
    kconfig
    kconfigwidgets
    kwindowsystem
    kiconthemes
    kwayland
  ];

  meta = with lib; {
    description = "Material-ish window decoration theme for KWin";
    homepage = "https://github.com/Zren/material-decoration";
    license = licenses.gpl2;
    maintainers = [ maintainers.nickcao ];
  };
}
