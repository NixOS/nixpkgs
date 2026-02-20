{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  qt6Packages,
  hunspell,
  withLua ? true,
  lua,
  withPython ? true,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texworks";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "TeXworks";
    repo = "texworks";
    rev = "release-${finalAttrs.version}";
    sha256 = "sha256-JygsOTryLXpFodwPGbPH3Baawl8k1Qkx2StZ1naInCc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    hunspell
    qt6Packages.poppler
    qt6.qt5compat
    qt6.qttools
  ]
  ++ lib.optional withLua lua
  ++ lib.optional withPython python3
  ++ lib.optional stdenv.hostPlatform.isLinux qt6.qtwayland;

  cmakeFlags = [
    "-DQT_DEFAULT_MAJOR_VERSION=6"
  ]
  ++ lib.optional withLua "-DWITH_LUA=ON"
  ++ lib.optional withPython "-DWITH_PYTHON=ON";

  meta = {
    changelog = "https://github.com/TeXworks/texworks/blob/${finalAttrs.src.rev}/NEWS";
    description = "Simple TeX front-end program inspired by TeXShop";
    homepage = "http://www.tug.org/texworks/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
    mainProgram = "texworks";
  };
})
