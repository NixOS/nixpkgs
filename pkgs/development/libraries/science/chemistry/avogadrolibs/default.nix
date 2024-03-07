{ lib, stdenv, fetchFromGitHub, cmake, zlib, eigen, libGL, doxygen, spglib
, mmtf-cpp, glew, python3, libarchive, libmsym, msgpack, qttools, wrapQtAppsHook
}:

let
  pythonWP = python3.withPackages (p: with p; [ openbabel-bindings numpy ]);

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

in stdenv.mkDerivation rec {
  pname = "avogadrolibs";
  version = "1.98.1";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = pname;
    rev = version;
    hash = "sha256-BuBMWW7N5Cu9tw5Vpwk+aoIaMWwHViRzLtIG7XDWjN4=";
  };

  postUnpack = ''
    cp -r ${moleculesRepo} molecules
    cp -r ${crystalsRepo} crystals
  '';

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
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
