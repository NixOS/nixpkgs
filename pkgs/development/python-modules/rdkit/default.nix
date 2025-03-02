{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  comic-neue,
  boost,
  catch2_3,
  inchi,
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
    yaehmop = fetchFromGitHub {
      owner = "greglandrum";
      repo = "yaehmop";
      rev = "v2024.03.1";
      hash = "sha256-rhR7Ev+9Fk/Ks7R2x2SjWu1L/48a4zHDHUBohx1Dw/M=";
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
  };
  boost' = boost.override { enableNumpy = true; };
in
buildPythonPackage rec {
  pname = "rdkit";
  version = "2024.09.1";
  pyproject = false;

  src =
    let
      versionTag = lib.replaceStrings [ "." ] [ "_" ] version;
    in
    fetchFromGitHub {
      owner = "rdkit";
      repo = "rdkit";
      rev = "Release_${versionTag}";
      hash = "sha256-UsyPlAJ8FISblF8szEmRqWansunIhW/gbEBZx13YM+A=";
    };

  unpackPhase = ''
    cp -r $src/* .
    find . -type d -exec chmod +w {} +

    mkdir External/AvalonTools/avalon
    # In buildPhase, CMake patches the file in this directory
    # see https://github.com/rdkit/rdkit/pull/5928
    cp -r ${external.avalon}/* External/AvalonTools/avalon

    mkdir External/YAeHMOP/yaehmop
    ln -s ${external.yaehmop}/* External/YAeHMOP/yaehmop

    mkdir -p External/FreeSASA/freesasa
    cp -r ${external.freesasa}/* External/FreeSASA/freesasa
    chmod +w External/FreeSASA/freesasa/src
    cp External/FreeSASA/freesasa2.c External/FreeSASA/freesasa/src

    ln -s ${external.pubchem-align3d} External/pubchem_shape/pubchem-align3d
    ln -s ${rapidjson} External/rapidjson-1.1.0
    ln -s ${comic-neue}/share/fonts/truetype/ComicNeue-Regular.ttf Data/Fonts/
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost'
    cairo
    catch2_3
    coordgenlibs
    eigen
    inchi
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
    (lib.cmakeBool "RDK_BUILD_YAEHMOP_SUPPORT" true)
    (lib.cmakeBool "RDK_INSTALL_INTREE" false)
    (lib.cmakeBool "RDK_INSTALL_STATIC_LIBS" false)
    (lib.cmakeBool "RDK_TEST_MULTITHREADED" true)
    (lib.cmakeBool "RDK_TEST_MULTITHREADED" true)
    (lib.cmakeBool "RDK_USE_FLEXBISON" false)
    (lib.cmakeBool "RDK_USE_URF" false)
    (lib.cmakeFeature "AVALONTOOLS_DIR" "avalon")
    (lib.cmakeFeature "FREESASA_SRC_DIR" "freesasa")
    (lib.cmakeFeature "INCHI_INCLUDE_DIR" "${inchi}/include/inchi")
    (lib.cmakeFeature "PUBCHEMSHAPE_DIR" "External/pubchem_shape/pubchem-align3d")
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
  ];

  meta = with lib; {
    description = "Open source toolkit for cheminformatics";
    maintainers = with maintainers; [
      rmcgibbo
      natsukium
    ];
    license = licenses.bsd3;
    homepage = "https://www.rdkit.org";
    changelog = "https://github.com/rdkit/rdkit/releases/tag/${src.rev}";
  };
}
