{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  eigen,
  libGL,
  spglib,
  mmtf-cpp,
  glew,
  python3,
  libarchive,
  libmsym,
  jkqtplotter,
  qt6,
}:

let
  pythonWP = python3.withPackages (
    p: with p; [
      openbabel
      numpy
    ]
  );

  # Pure data repositories
  moleculesRepo = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "molecules";
    tag = "1.103.0";
    hash = "sha256-hMLf0gYYnQpjSGKcPy4tihNbmpRR7UxnXF/hyhforgI=";
  };
  crystalsRepo = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "crystals";
    tag = "1.103.0";
    hash = "sha256-WhzFldaOt/wJy1kk+ypOkw1OYFT3hqD7j5qGdq9g+IY=";
  };
  fragmentsRepo = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "fragments";
    tag = "1.103.0";
    hash = "sha256-jH8k+qPlyU3Tset63uxrDlMFLdcWh8JhJoe5sl1pJ2E=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "avogadrolibs";
  version = "1.103.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadrolibs";
    tag = finalAttrs.version;
    hash = "sha256-2SuSNaZnY3LXcUuGboc8ZRCCeoClENoYtWmNNahdor4=";
  };

  postUnpack = ''
    cp -r ${moleculesRepo} molecules
    cp -r ${crystalsRepo} crystals
    cp -r ${fragmentsRepo} fragments
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pythonWP
  ];

  buildInputs = [
    eigen
    zlib
    libGL
    spglib
    mmtf-cpp
    glew
    libarchive
    libmsym
    jkqtplotter
    qt6.qttools
  ];

  # Fix the broken CMake files to use the correct paths
  postInstall = ''
    substituteInPlace $out/lib/cmake/avogadrolibs/AvogadroLibsConfig.cmake \
      --replace "$out/" ""

    substituteInPlace $out/lib/cmake/avogadrolibs/AvogadroLibsTargets.cmake \
      --replace "_IMPORT_PREFIX}/$out" "_IMPORT_PREFIX}/"
  '';

  meta = {
    description = "Molecule editor and visualizer";
    maintainers = with lib.maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/avogadrolibs";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
})
