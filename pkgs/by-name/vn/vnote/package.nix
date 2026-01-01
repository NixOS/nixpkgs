{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchpatch,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnote";
<<<<<<< HEAD
  version = "3.20.1";
=======
  version = "3.19.2-unstable-2025-10-12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
<<<<<<< HEAD
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

=======
    rev = "1ebe3fd4ecef69c2bacb7f2ec915666f99195ce1";
    fetchSubmodules = true;
    hash = "sha256-vbud2IjmkIIkuZ7ocrQ199CEsKy1nMnidGe/d0UN9jU=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
