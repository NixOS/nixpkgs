{
  lib,
  stdenv,
  fetchzip,
  cmake,
  sqlite,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tagainijisho";
  version = "1.2.2";

  src = fetchzip {
    url = "https://github.com/Gnurou/tagainijisho/releases/download/${finalAttrs.version}/tagainijisho-${finalAttrs.version}.tar.gz";
    hash = "sha256-CTDMoYGbVE4W0SDerW//aAdUVsySWFQycSy0I3a9+94=";
  };

  patches = [
    ### Fix cmake minimum version
    ./0000-fix-cmake-min.patch
  ];

  nativeBuildInputs = [
    qt5.qttools
    cmake
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    qt5.qtbase
    sqlite
  ];

  cmakeFlags = [
    "-DEMBED_SQLITE=OFF"
  ];

  meta = {
    description = "Free, open-source Japanese dictionary and kanji lookup tool";
    mainProgram = "tagainijisho";
    homepage = "https://www.tagaini.net/";
    license = with lib.licenses; [
      # program
      gpl3Plus
      # data
      cc-by-sa-30
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
