{
  lib,
  stdenv,
  testers,
  buildPythonPackage,
  pythonOlder,
  python,
  pytestCheckHook,
  # fetchers
  fetchFromGitHub,
  gitUpdater,
  # build tools
  cmake,
  swig,
  # native dependencies
  eigen,
  boost179,
  cgal,
  gmp,
  hdf5,
  icu,
  libaec,
  libxml2,
  mpfr,
  nlohmann_json,
  opencascade-occt_7_6,
  opencollada,
  pcre,
  zlib,

  # python deps
  ## tools
  setuptools,
  build,
  pytest,
  ## dependencies
  isodate,
  lark,
  numpy,
  python-dateutil,
  shapely,
  typing-extensions,
  ## additional deps for tests
  ifcopenshell,
  lxml,
  mathutils,
  networkx,
  tabulate,
  xmlschema,
  xsdata,
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
buildPythonPackage rec {
  pname = "ifcopenshell";
  version = "0.8.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "IfcOpenShell";
    repo = "IfcOpenShell";
    rev = "refs/tags/ifcopenshell-python-${version}";
    fetchSubmodules = true;
    hash = "sha256-tnj14lBEkUZNDM9J1sRhNA7OkWTWa5JPTSF8hui3q7k=";
  };

  nativeBuildInputs = [
    # c++
    cmake
    swig
    # python
    build
    setuptools
  ];

  buildInputs = [
    # ifcopenshell needs stdc++
    (lib.getLib stdenv.cc.cc)
    boost179
    cgal
    eigen
    gmp
    hdf5
    icu
    libaec
    libxml2
    mpfr
    nlohmann_json
    opencascade-occt
    opencollada
    pcre
  ];

  propagatedBuildInputs = [
    isodate
    lark
    numpy
    python-dateutil
    shapely
    typing-extensions
  ];

  # list taken from .github/workflows/ci.yml:49
  nativeCheckInputs = [
    lxml
    mathutils
    networkx
    pytest
    tabulate
    xmlschema
    xsdata

    pytestCheckHook
  ];

  pythonImportsCheck = [ "ifcopenshell" ];

  PYTHONUSERBASE = ".";

  # We still build with python to generate ifcopenshell_wrapper.py and ifcopenshell_wrapper.so
  cmakeFlags = [
    "-DUSERSPACE_PYTHON_PREFIX=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_IFCPYTHON=ON"
    "-DCITYJSON_SUPPORT=OFF"
    "-DEIGEN_DIR=${eigen}/include/eigen3"
    "-DJSON_INCLUDE_DIR=${nlohmann_json}/include/"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    "-DOCC_LIBRARY_DIR=${lib.getLib opencascade-occt}/lib"
    "-DOPENCOLLADA_INCLUDE_DIR=${opencollada}/include/opencollada"
    "-DOPENCOLLADA_LIBRARY_DIR=${lib.getLib opencollada}/lib/opencollada"
    "-DSWIG_EXECUTABLE=${swig}/bin/swig"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${lib.getLib libxml2}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DGMP_LIBRARY_DIR=${lib.getLib gmp}/lib/"
    "-DMPFR_LIBRARY_DIR=${lib.getLib mpfr}/lib/"
    # HDF5 support is currently not optional, see https://github.com/IfcOpenShell/IfcOpenShell/issues/1815
    "-DHDF5_SUPPORT=ON"
    "-DHDF5_INCLUDE_DIR=${hdf5.dev}/include/"
    "-DHDF5_LIBRARIES=${lib.getLib hdf5}/lib/libhdf5_cpp.so;${lib.getLib hdf5}/lib/libhdf5.so;${lib.getLib zlib}/lib/libz.so;${lib.getLib libaec}/lib/libaec.so;"
  ];

  postPatch = ''
    pushd src/ifcopenshell-python
    # The build process is here: https://github.com/IfcOpenShell/IfcOpenShell/blob/v0.8.0/src/ifcopenshell-python/Makefile#L131
    # NOTE: it has changed a *lot* between 0.7.0 and 0.8.0, it *may* change again (look for mathutils and basically all the things this Makefile does manually)
    substituteInPlace pyproject.toml --replace-fail "0.0.0" "${version}"
    # NOTE: the following is directly inspired by https://github.com/IfcOpenShell/IfcOpenShell/blob/v0.8.0/src/ifcopenshell-python/Makefile#L123
    cp ../../README.md README.md
    popd
  '';

  preConfigure = ''
    cd cmake
  '';

  preCheck = ''
    pushd ../../src/ifcopenshell-python
    # let's test like done in .github/workflows/ci.yml
    # installing the python wrapper and the .so, both are needed to be able to test
    cp -v $out/${python.sitePackages}/ifcopenshell/ifcopenshell_wrapper.py ./ifcopenshell
    cp $out/${python.sitePackages}/ifcopenshell/_ifcopenshell_wrapper.cpython-${
      lib.versions.major python.version + lib.versions.minor python.version
    }-${stdenv.targetPlatform.system}-gnu.so ./ifcopenshell
    pushd ../../test
    PYTHONPATH=../src/ifcopenshell-python/ python tests.py
    popd
  '';

  pytestFlagsArray = [
    "-p no:pytest-blender"
  ];

  disabledTestPaths = [
    "test/test_open.py"
  ];

  postCheck = ''
    popd
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "ifcopenshell-python-"; };
    tests = {
      version = testers.testVersion {
        command = "IfcConvert --version";
        package = ifcopenshell;
      };
    };
  };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Open source IFC library and geometry engine";
    homepage = "http://ifcopenshell.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ autra ];
  };
}
