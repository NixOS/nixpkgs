{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  replaceVars,
  cmake,
  comic-neue,
  boost,
  catch2_3,
  cairo,
  eigen,
  python,
  rapidjson,
  maeparser,
  coordgenlibs,
  numpy,
  pandas,
  pillow,

  # tests
  pytest,
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
      tag = "v1.0.14";
      hash = "sha256-u3MSQqXzA0rGBH7KF96LlxBgR5twerQwY3cM0Rhf530=";
    };
    yaehmop = fetchFromGitHub {
      owner = "greglandrum";
      repo = "yaehmop";
      tag = "v2025.03.2";
      hash = "sha256-YwP0uj6QLwby30hVESAtu1rv5pLTFhi0+EXN5IqICq8=";
    };
    ringdecomposerlib = fetchFromGitHub {
      owner = "rareylab";
      repo = "RingDecomposerLib";
      tag = "v1.1.3_rdkit";
      hash = "sha256-kYO37mHFCffQgM7jt+Op7cy8gNWE9d84ILHNebnQv+c=";
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
buildPythonPackage (finalAttrs: {
  pname = "rdkit";
  version = "2026.09.1";
  pyproject = false;
  __structuredAttrs = true;

  src =
    let
      versionTag = lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
    in
    fetchFromGitHub {
      owner = "rdkit";
      repo = "rdkit";
      tag = "Release_${versionTag}";
      hash = "sha256-OH9g0qiOBT5f5sLf6944VjMt6obBzRoB3nUfhZd+gTk=";
    };

  unpackPhase = ''
    cp -r $src/* .
    chmod -R u+w .

    mkdir External/AvalonTools/avalon
    # In buildPhase, CMake patches the file in this directory
    # see https://github.com/rdkit/rdkit/pull/5928
    cp -r ${external.avalon}/* External/AvalonTools/avalon

    mkdir External/ChemDraw/chemdraw
    cp -r ${external.chemdraw}/* External/ChemDraw/chemdraw/
    chmod -R +w External/ChemDraw/chemdraw

    mkdir External/YAeHMOP/yaehmop
    ln -s ${external.yaehmop}/* External/YAeHMOP/yaehmop

    mkdir External/RingFamilies/RingDecomposerLib
    cp -r ${external.ringdecomposerlib}/* External/RingFamilies/RingDecomposerLib
    chmod -R +w External/RingFamilies/RingDecomposerLib

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

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost'
    cairo
    catch2_3
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
    # Register the tests with ctest (the cmake hook disables it, as `doCheck` is false for python packages)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doInstallCheck)
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
    (lib.cmakeFeature "AVALONTOOLS_DIR" "avalon")
    (lib.cmakeFeature "FREESASA_SRC_DIR" "freesasa")
    (lib.cmakeFeature "maeparser_DIR" "${maeparser}/lib/cmake")
    (lib.cmakeFeature "coordgen_DIR" "${coordgenlibs}/lib/cmake")
  ];

  # The CMake build does not produce any .dist-info, which makes the runtime dependency check of
  # reverse dependencies fail. Install a minimal one so that `importlib.metadata` finds rdkit.
  postInstall = ''
    distInfo="$out/${python.sitePackages}/rdkit-${finalAttrs.version}.dist-info"
    mkdir -p "$distInfo"
    cat > "$distInfo/METADATA" <<EOF
    Metadata-Version: 2.1
    Name: rdkit
    Version: ${finalAttrs.version}
    EOF
    echo "nix" > "$distInfo/INSTALLER"
  '';

  nativeCheckInputs = [ pytest ];

  disabledCtests = [
    # Drawing coordinates depend on the text rendering of the legend
    "moldraw2DTestCatch"
    # Runs pytest on the source tree, which shadows the installed (compiled) package
    "pythonSourceTests"
  ];

  # Run the C++ and Python test suites through ctest, against the installed package
  checkPhase = ''
    runHook preCheck

    export QT_QPA_PLATFORM='offscreen'
    export RDBASE=$(realpath ..)
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
    export LD_LIBRARY_PATH="$out/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export DYLD_LIBRARY_PATH="$out/lib''${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}"
    ctest --output-on-failure -j $NIX_BUILD_CORES -E "^(${lib.concatStringsSep "|" finalAttrs.disabledCtests})$"

    runHook postCheck
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
    changelog = "https://github.com/rdkit/rdkit/releases/tag/${finalAttrs.src.tag}";
  };
})
