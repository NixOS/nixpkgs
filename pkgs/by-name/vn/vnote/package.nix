{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnote";
  version = "3.20.1";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Ukik02qP7a86dgBTghD9wGKGpXkdGdxczg01APtcOAM=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/vnotex/vnote/commit/7c59d0d061d30f8f1f57eab855b73d3b1f452df1.patch";
      hash = "sha256-gt2JDO9kGR/bjTtqTaAdHDHm9UC3XMG6KgKeDdhhNNg=";
    })
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    qt6.qtsvg
    qt6.qttools
    qt6.qt5compat
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://vnotex.github.io/vnote";
    description = "Pleasant note-taking platform";
    mainProgram = "vnote";
    changelog = "https://github.com/vnotex/vnote/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
