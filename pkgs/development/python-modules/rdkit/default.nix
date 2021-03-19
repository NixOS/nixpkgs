{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchzip
, cmake
, boost
, catch
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
, git
}:
let
  external = {
    avalon = fetchzip {
      url = "http://sourceforge.net/projects/avalontoolkit/files/AvalonToolkit_1.2/AvalonToolkit_1.2.0.source.tar";
      sha256 = "0nhxfxckb5a5qs0g148f55yarhncqjgjzcvdskkv9rxi2nrs7160";
      stripRoot = false;
    };
    yaehmop = fetchFromGitHub {
      owner = "greglandrum";
      repo = "yaehmop";
      rev = "1b13b52e2738a77715b1bad876e3b4e93f2b5269";
      sha256 = "1jp7wz8win4mgwxkaz2gnrgsaaqgln04n2lwgfr96isdv1klf62d";
    };
    freesasa = fetchFromGitHub
      {
        owner = "mittinatten";
        repo = "freesasa";
        rev = "2.0.3";
        sha256 = "0x686zm9fpyg5647fdgxnxgbwav99nc6ymh4bmkr2063yyda4kzc";
      };
  };
in
buildPythonPackage rec {
  pname = "rdkit";
  version = "2020.09.5";

  src =
    let
      versionTag = lib.replaceStrings [ "." ] [ "_" ] version;
    in
    fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "Release_${versionTag}";
      sha256 = "1ycbjia223d0w9xiwk36x2vkdidsx198rzkfyxz48cbax9vvklzq";
    };

  unpackPhase = ''
    mkdir -p source/External/AvalonTools/avalon source/External/YAeHMOP/yaehmop source/External/FreeSASA/freesasa
    cp -r ${src}/* source
    cp -r ${external.avalon}/SourceDistribution/* source/External/AvalonTools/avalon
    cp -r ${external.yaehmop}/* source/External/YAeHMOP/yaehmop
    cp -r ${external.freesasa}/* source/External/FreeSASA/freesasa

    find source -type d -exec chmod 755 {} +
    cp source/External/FreeSASA/freesasa2.c source/External/FreeSASA/freesasa/src
    ln -s ${rapidjson} source/External/rapidjson-1.1.0
  '';

  sourceRoot = "source";

  nativeBuildInputs = [
    cmake
    git # required by freesasa
  ];

  buildInputs = [
    boost
    catch
    inchi
    eigen
    cairo
    rapidjson
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
    # Don't want this contacting the git remote during the build
    substituteInPlace External/YAeHMOP/CMakeLists.txt --replace \
      'GIT_TAG master' 'DOWNLOAD_COMMAND true'

    # Since we can't expand with bash in cmakeFlags
    cmakeFlags="$cmakeFlags -DPYTHON_NUMPY_INCLUDE_PATH=$(${python}/bin/python -c 'import numpy; print(numpy.get_include())')"
    cmakeFlags="$cmakeFlags -DFREESASA_DIR=$PWD/External/FreeSASA/freesasa"
    cmakeFlags="$cmakeFlags -DFREESASA_SRC_DIR=$PWD/External/FreeSASA/freesasa"
    cmakeFlags="$cmakeFlags -DAVALONTOOLS_DIR=$PWD/External/AvalonTools/avalon"
  '';

  cmakeFlags = [
    "-DCATCH_DIR=${catch}/include/catch"
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
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
    homepage = "https://www.rdkit.org";
  };
}
