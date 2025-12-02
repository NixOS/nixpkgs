{
  lib,

  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  libsForQt5,

  # buildInputs
  corto,
  glew,
  llvmPackages,
  vcg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nexus";
  version = "2025.05";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "nexus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lC3nKQJwkixwGzPP/oS0J+WIFgYqky6NaXu9bX28+3I=";
  };

  outputs = [
    "out"
    "bin"
  ];

  patches = [
    # CMake: install lib & exports
    # ref. https://github.com/cnr-isti-vclab/nexus/pull/173
    # merged upstream
    (fetchpatch {
      url = "https://github.com/cnr-isti-vclab/nexus/commit/141ba17059f3680a74ce1178ed4245412f76061f.patch";
      hash = "sha256-iY84QIpliC1BIImI/6S6E6fQwMKPmmTiwouCXW6wLuM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    corto
    glew
    libsForQt5.qtbase
    vcg
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_NXS_VIEW" (!stdenv.hostPlatform.isDarwin))
  ];

  meta = {
    description = "Library for creation and visualization of a batched multiresolution mesh";
    homepage = "https://github.com/cnr-isti-vclab/nexus";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "nxsview";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
