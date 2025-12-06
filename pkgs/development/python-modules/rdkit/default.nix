{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  applyPatches,
  replaceVars,
  cmake,
  comic-neue,
  boost,
  catch2,
  cairo,
  eigen,
  python,
  rapidjson,
  maeparser,
  coordgenlibs,
  numpy,
  pandas,
  pillow,
}:
let
  external = {
    avalon = fetchFromGitHub {
      owner = "rdkit";
      repo = "ava-formake";
      rev = "AvalonToolkit_2.0.5-pre.3";
      hash = "sha256-2MuFZgRIHXnkV7Nc1da4fa7wDx57VHUtwLthrmjk+5o=";
    };
    chemdraw = fetchFromGitHub {
      owner = "Glysade";
      repo = "chemdraw";
      tag = "v1.0.10";
      hash = "sha256-ee2Oxvo2d7Yb59lN0zkrbFqy/3rOvVLo6qdS+f23wVQ=";
    };
    yaehmop = applyPatches {
      src = fetchFromGitHub {
        owner = "greglandrum";
        repo = "yaehmop";
        rev = "v2025.03.1";
        hash = "sha256-rhR7Ev+9Fk/Ks7R2x2SjWu1L/48a4zHDHUBohx1Dw/M=";
      };

      # Compatibility with CMake < 3.5 has been removed from CMake.
      postPatch = ''
        substituteInPlace tightbind/CMakeLists.txt \
          --replace-fail \
            "cmake_minimum_required(VERSION 3.0)" \
            "cmake_minimum_required(VERSION 3.5)"
      '';
    };
    freesasa = fetchFromGitHub {
      owner = "mittinatten";
      repo = "freesasa";
      rev = "2.0.3";
      hash = "sha256-7E+imvfDAJFnXQRWb5hNaSu+Xrf9NXeIKc9fl+o3yHQ=";
    };
    pubchem-align3d = fetchFromGitHub {
      owner = "ncbi";
      repo = "pubchem-align3d";
      rev = "daefab3dd0c90ca56da9d3d5e375fe4d651e6be3";
      hash = "sha256-tQB4wqza9rlSoy4Uj9bA99ddawjxGyN9G7DYbcv/Qdo=";
    };
    better_enums = fetchFromGitHub {
      owner = "aantron";
      repo = "better-enums";
      tag = "0.11.3";
      hash = "sha256-UYldCOkRTySc78oEOJzgoY9h2lB386W/D5Rz3KjVCO8=";
    };
    # We cannot use the inchi from nixpkgs as the version is too old
    inchi = fetchzip {
      url = "https://github.com/IUPAC-InChI/InChI/releases/download/v1.07.3/INCHI-1-SRC.zip";
      hash = "sha256-TUC2175HifB63EfSsg/ixA3wYzAxsvUnY6ZyNjVR/Fc=";
    };
  };
  boost' = boost.override { enableNumpy = true; };
in
buildPythonPackage rec {
  pname = "rdkit";
  version = "2025.03.6";
  pyproject = false;

  src =
    let
      versionTag = lib.replaceStrings [ "." ] [ "_" ] version;
    in
    fetchFromGitHub {
      owner = "rdkit";
      repo = "rdkit";
      tag = "Release_${versionTag}";
      hash = "sha256-DqnwfT+lX7OnArIcFlCBrDl+QDmNpbPO9u7OGwu8fJo=";
    };

  unpackPhase = ''
    cp -r $src/* .
    find . -type d -exec chmod +w {} +

    mkdir External/AvalonTools/avalon
    # In buildPhase, CMake patches the file in this directory
    # see https://github.com/rdkit/rdkit/pull/5928
    cp -r ${external.avalon}/* External/AvalonTools/avalon

    mkdir External/ChemDraw/chemdraw
    cp -r ${external.chemdraw}/* External/ChemDraw/chemdraw/
    chmod -R +w External/ChemDraw/chemdraw

    mkdir External/YAeHMOP/yaehmop
    ln -s ${external.yaehmop}/* External/YAeHMOP/yaehmop

    mkdir External/FreeSASA/freesasa
    cp -r ${external.freesasa}/* External/FreeSASA/freesasa
    chmod +w External/FreeSASA/freesasa/src
    cp External/FreeSASA/freesasa2.c External/FreeSASA/freesasa/src

    mkdir External/pubchem_shape/pubchem-align3d
    cp -r ${external.pubchem-align3d}/* External/pubchem_shape/pubchem-align3d

    mkdir External/INCHI-API/src
    ln -s ${external.inchi}/* External/INCHI-API/src

    ln -s ${rapidjson} External/rapidjson-1.1.0
    ln -s ${comic-neue}/share/fonts/truetype/ComicNeue-Regular.ttf Data/Fonts/
  '';

  patches = [
    (replaceVars ./dont-fetch-better-enums.patch {
      inherit (external) better_enums;
    })
  ];

  # Prevent linking to libpython which fails on darwin with:
  # Undefined symbols for architecture arm64
  # Reverts https://github.com/rdkit/rdkit/commit/470df8cd2fab78d64ef1dd254576097b651c3dd9
  postPatch = ''
    substituteInPlace \
      CMakeLists.txt \
      External/pubchem_shape/Wrap/CMakeLists.txt \
      --replace-fail \
        "find_package(Python3 COMPONENTS Interpreter Development.Module NumPy" \
        "find_package(Python3 COMPONENTS Interpreter Development NumPy" \
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost'
    cairo
    catch2
    coordgenlibs
    eigen
    maeparser
  ];

  dependencies = [
    numpy
    pandas
    pillow
  ];

  hardeningDisable = [ "format" ]; # required by yaehmop

  cmakeFlags = [
    (lib.cmakeBool "Boost_NO_BOOST_CMAKE" true)
    (lib.cmakeBool "Boost_NO_SYSTEM_PATHS" true)
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true) # fails to find libs in pythonImportsCheckPhase otherwise
    (lib.cmakeBool "RDK_BUILD_AVALON_SUPPORT" true)
    (lib.cmakeBool "RDK_BUILD_CAIRO_SUPPORT" true)
    (lib.cmakeBool "RDK_BUILD_COORDGEN_SUPPORT" true)
    (lib.cmakeBool "RDK_BUILD_CPP_TESTS" true)
    (lib.cmakeBool "RDK_BUILD_FREESASA_SUPPORT" true)
    (lib.cmakeBool "RDK_BUILD_INCHI_SUPPORT" true)
    (lib.cmakeBool "RDK_BUILD_MAEPARSER_SUPPORT" true)
    (lib.cmakeBool "RDK_BUILD_THREADSAFE_SSS" true)
    (lib.cmakeBool "RDK_BUILD_XYZ2MOL_SUPPORT" true)
    (lib.cmakeBool "RDK_BUILD_YAEHMOP_SUPPORT" true)
    (lib.cmakeBool "RDK_INSTALL_INTREE" false)
    (lib.cmakeBool "RDK_INSTALL_STATIC_LIBS" false)
    (lib.cmakeBool "RDK_TEST_MULTITHREADED" true)
    (lib.cmakeBool "RDK_USE_FLEXBISON" false)
    (lib.cmakeBool "RDK_USE_URF" false)
    (lib.cmakeFeature "AVALONTOOLS_DIR" "avalon")
    (lib.cmakeFeature "FREESASA_SRC_DIR" "freesasa")
    (lib.cmakeFeature "maeparser_DIR" "${maeparser}/lib/cmake")
    (lib.cmakeFeature "coordgen_DIR" "${coordgenlibs}/lib/cmake")
  ];

  checkPhase = ''
    export QT_QPA_PLATFORM='offscreen'
    export RDBASE=$(realpath ..)
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
    (cd $RDBASE/rdkit/Chem && python $RDBASE/rdkit/TestRunner.py test_list.py)
  '';

  pythonImportsCheck = [
    "rdkit"
    "rdkit.Chem"
    "rdkit.Chem.AllChem"
    "rdkit.Chem.rdDetermineBonds"
  ];

  meta = {
    description = "Open source toolkit for cheminformatics";
    maintainers = with lib.maintainers; [
      rmcgibbo
      natsukium
    ];
    license = lib.licenses.bsd3;
    homepage = "https://www.rdkit.org";
    changelog = "https://github.com/rdkit/rdkit/releases/tag/${src.tag}";
  };
}
