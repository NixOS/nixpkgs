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
      openbabel-bindings
      numpy
    ]
  );

  # Pure data repositories
  moleculesRepo = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "molecules";
    rev = "1.0.0";
    sha256 = "guY6osnpv7Oqt+HE1BpIqL10POp+x8GAci2kY0bLmqg=";
  };
  crystalsRepo = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "crystals";
    rev = "1.0.1";
    sha256 = "sH/WuvLaYu6akOc3ssAKhnxD8KNoDxuafDSozHqJZC4=";
  };
  fragmentsRepo = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "fragments";
    rev = "8dc711a59d016604b3e9b6d59dec178b8e6ccd36";
    hash = "sha256-Valc5zwlaZ//eDupFouCfWCeID7/4ObU1SDLFJ/mo/g=";
  };

in
stdenv.mkDerivation rec {
  pname = "avogadrolibs";
  version = "1.100.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = pname;
    rev = version;
    hash = "sha256-zDn5cgMBJYM27mfQHujxhIf4ZTljFxvFrKl7pNa4K9E=";
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
    substituteInPlace $out/lib/cmake/${pname}/AvogadroLibsConfig.cmake \
      --replace "$out/" ""

    substituteInPlace $out/lib/cmake/${pname}/AvogadroLibsTargets.cmake \
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
