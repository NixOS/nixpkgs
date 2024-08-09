{
  lib,
  stdenv,
  testers,
  buildPythonPackage,
  pythonOlder,
  # fetchers
  fetchFromGitHub,
  # build tools
  cmake,
  gcc10,
  python,
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
  wheel,
  pytest,
  ## dependencies
  isodate,
  lark,
  numpy,
  python-dateutil,
  shapely,
  typing-extensions,
  ## additional deps for tests
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
  version = "0.7.10";
  format = "other";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "IfcOpenShell";
    repo = "IfcOpenShell";
    rev = "refs/tags/ifcopenshell-python-${version}";
    fetchSubmodules = true;
    hash = "sha256-cRzv07T5VN5aTjMtAlLGbvI3c4SL0lfzCn/W6f/vdBY=";
  };

  nativeBuildInputs = [
    # c++
    cmake
    gcc10
    swig
    # python
    build
    python
    setuptools
    wheel
  ];

  buildInputs = [
    # ifcopenshell needs stdc++
    stdenv.cc.cc.lib
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
    "-DOCC_LIBRARY_DIR=${opencascade-occt}/lib"
    "-DOPENCOLLADA_INCLUDE_DIR=${opencollada}/include/opencollada"
    "-DOPENCOLLADA_LIBRARY_DIR=${opencollada}/lib/opencollada"
    "-DSWIG_EXECUTABLE=${swig}/bin/swig"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${libxml2.out}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DGMP_LIBRARY_DIR=${gmp.out}/lib/"
    "-DMPFR_LIBRARY_DIR=${mpfr.out}/lib/"
    # HDF5 support is currently not optional, see https://github.com/IfcOpenShell/IfcOpenShell/issues/1815
    "-DHDF5_SUPPORT=ON"
    "-DHDF5_INCLUDE_DIR=${hdf5.dev}/include/"
    "-DHDF5_LIBRARIES=${hdf5.out}/lib/libhdf5_cpp.so;${hdf5.out}/lib/libhdf5.so;${zlib.out}/lib/libz.so;${libaec.out}/lib/libaec.so;" # /usr/lib64/libsz.so;"
  ];

  preConfigure = ''
    pushd src/ifcopenshell-python
    # The build process is here: https://github.com/IfcOpenShell/IfcOpenShell/blob/v0.8.0/src/ifcopenshell-python/Makefile#L131
    # NOTE: it has changed a *lot* between 0.7.0 and 0.8.0, it *may* change again (look for mathutils and basically all the things this Makefile does manually)
    substituteInPlace pyproject.toml --replace-fail "0.0.0" "${version}"
    # NOTE: the following is directly inspired by https://github.com/IfcOpenShell/IfcOpenShell/blob/v0.8.0/src/ifcopenshell-python/Makefile#L123
    cp README.md ../README.bak
    cp ../../README.md README.md
    popd
    cd cmake
  '';

  # let's test like done in .github/workflows/ci.yml
  checkPhase = ''
    cd ../../src/ifcopenshell-python
    # installing the python wrapper and the .so, both are needed to be able to test
    ifcopenshell_py_wrapper_path=$(find $out -name ifcopenshell_wrapper.py)
    cp -v $ifcopenshell_py_wrapper_path ./ifcopenshell
    ifcopenshell_so_path=$(find $out -name "*ifcopenshell_wrapper*.so")
    cp -v $ifcopenshell_so_path ./ifcopenshell
    pushd ../../test
    PYTHONPATH=../src/ifcopenshell-python/ python tests.py
    popd
    # like make test-safe, but also ignoring test/test_open.py which segfaults (this needs to be investigated)
    pytest -p no:pytest-blender test --ignore=test/util/test_shape_builder.py --ignore=test/test_open.py
  '';

  passthru.tests = {
    version = testers.testVersion { command = "IfcConvert --version"; };
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Open source IFC library and geometry engine";
    homepage = "http://ifcopenshell.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ autra ];
  };
}
