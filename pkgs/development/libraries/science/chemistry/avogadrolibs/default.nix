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
  msgpack,
  qttools,
  wrapQtAppsHook,
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
    tag = "1.101.0";
    hash = "sha256-hMLf0gYYnQpjSGKcPy4tihNbmpRR7UxnXF/hyhforgI=";
  };
  crystalsRepo = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "crystals";
    tag = "1.101.0";
    hash = "sha256-WhzFldaOt/wJy1kk+ypOkw1OYFT3hqD7j5qGdq9g+IY=";
  };
  fragmentsRepo = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "fragments";
    tag = "1.101.0";
    hash = "sha256-x10jGl3lAEfm8OxUZJnjXRJCQg8RLQZTstjwnt5B2bw=";
  };

in
stdenv.mkDerivation rec {
  pname = "avogadrolibs";
  version = "1.101.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadrolibs";
    tag = version;
    hash = "sha256-0DJU40Etse90rdX8xByjQeUiBsJtEQozZQQsWsc4vxk=";
  };

  postUnpack = ''
    cp -r ${moleculesRepo} molecules
    cp -r ${crystalsRepo} crystals
    cp -r ${fragmentsRepo} fragments
  '';

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
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
    msgpack
    qttools
  ];

  # Fix the broken CMake files to use the correct paths
  postInstall = ''
    substituteInPlace $out/lib/cmake/avogadrolibs/AvogadroLibsConfig.cmake \
      --replace "$out/" ""

    substituteInPlace $out/lib/cmake/avogadrolibs/AvogadroLibsTargets.cmake \
      --replace "_IMPORT_PREFIX}/$out" "_IMPORT_PREFIX}/"
  '';

  meta = with lib; {
    description = "Molecule editor and visualizer";
    maintainers = with maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/avogadrolibs";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
