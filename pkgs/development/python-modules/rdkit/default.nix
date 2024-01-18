{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cmake
, comic-neue
, boost
, catch2_3
, inchi
, cairo
, eigen
, python
, rapidjson
, maeparser
, coordgenlibs
, numpy
, pandas
, pillow
, memorymappingHook
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
      rev = "v2023.03.1";
      hash = "sha256-K9//cDN69U4sLETfIZq9NUaBE3RXOReH53qfiCzutqM=";
    };
    freesasa = fetchFromGitHub {
      owner = "mittinatten";
      repo = "freesasa";
      rev = "2.0.3";
      hash = "sha256-7E+imvfDAJFnXQRWb5hNaSu+Xrf9NXeIKc9fl+o3yHQ=";
    };
  };
in
buildPythonPackage rec {
  pname = "rdkit";
  version = "2023.09.3";
  pyproject = false;

  src =
    let
      versionTag = lib.replaceStrings [ "." ] [ "_" ] version;
    in
    fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "Release_${versionTag}";
      hash = "sha256-bewOdmpnm6cArD5iaMKNqT8z4GUIpih+JzJ+wdo/lrI=";
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

    ln -s ${rapidjson} External/rapidjson-1.1.0
    ln -s ${comic-neue}/share/fonts/truetype/ComicNeue-Regular.ttf Data/Fonts/
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    cairo
    catch2_3
  ] ++ lib.optionals (stdenv.system == "x86_64-darwin") [
    memorymappingHook
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    pillow
  ];

  hardeningDisable = [ "format" ]; # required by yaehmop

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;

  preConfigure = ''
    # Since we can't expand with bash in cmakeFlags
    cmakeFlags="$cmakeFlags -DPYTHON_NUMPY_INCLUDE_PATH=$(${python}/bin/python -c 'import numpy; print(numpy.get_include())')"
    cmakeFlags="$cmakeFlags -DFREESASA_DIR=$PWD/External/FreeSASA/freesasa"
    cmakeFlags="$cmakeFlags -DFREESASA_SRC_DIR=$PWD/External/FreeSASA/freesasa"
    cmakeFlags="$cmakeFlags -DAVALONTOOLS_DIR=$PWD/External/AvalonTools/avalon"
  '';

  cmakeFlags = [
    "-DINCHI_LIBRARY=${inchi}/lib/libinchi.so"
    "-DINCHI_LIBRARIES=${inchi}/lib/libinchi.so"
    "-DINCHI_INCLUDE_DIR=${inchi}/include/inchi"
    "-DEIGEN3_INCLUDE_DIR=${eigen}/include/eigen3"
    "-DRDK_INSTALL_INTREE=OFF"
    "-DRDK_INSTALL_STATIC_LIBS=OFF"
    "-DRDK_BUILD_INCHI_SUPPORT=ON"
    "-DRDK_BUILD_AVALON_SUPPORT=ON"
    "-DRDK_BUILD_FREESASA_SUPPORT=ON"
    "-DRDK_BUILD_YAEHMOP_SUPPORT=ON"
    "-DRDK_BUILD_MAEPARSER_SUPPORT=ON"
    "-DMAEPARSER_DIR=${maeparser}"
    "-DRDK_BUILD_COORDGEN_SUPPORT=ON"
    "-DCOORDGEN_DIR=${coordgenlibs}"
    "-DRDK_USE_URF=OFF"
    "-DRDK_USE_FLEXBISON=OFF"
    "-DRDK_BUILD_CAIRO_SUPPORT=ON"
    "-DRDK_BUILD_THREADSAFE_SSS=ON"
    "-DRDK_TEST_MULTITHREADED=ON"
    "-DRDK_BUILD_CPP_TESTS=ON"
    "-DRDK_TEST_MULTITHREADED=ON"
    "-DPYTHON_EXECUTABLE=${python}/bin/python"
    "-DBOOST_ROOT=${boost}"
    "-DBoost_NO_SYSTEM_PATHS=ON"
    "-DBoost_NO_BOOST_CMAKE=TRUE"
    "-DCMAKE_SKIP_BUILD_RPATH=ON" # fails to find libs in pythonImportsCheckPhase otherwise
  ];

  checkPhase = ''
    export QT_QPA_PLATFORM='offscreen'
    export RDBASE=$(realpath ..)
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
    (cd $RDBASE/rdkit/Chem && python $RDBASE/rdkit/TestRunner.py test_list.py)
  '';

  pythonImportsCheck = [
    "rdkit"
    "rdkit.Chem"
    "rdkit.Chem.AllChem"
  ];

  meta = with lib; {
    description = "Open source toolkit for cheminformatics";
    maintainers = with maintainers; [ rmcgibbo natsukium ];
    license = licenses.bsd3;
    homepage = "https://www.rdkit.org";
    changelog = "https://github.com/rdkit/rdkit/releases/tag/${src.rev}";
  };
}
