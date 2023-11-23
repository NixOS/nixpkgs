{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, stdenv
, ninja
, pybind11
, nanobind
, scikit-build
, setuptools
, wheel
, asmjit
, drjit
, drjit-core
, embree
, fast-float
, libjpeg
, libpng
, nanothread
, numpy
, openexr
, pugixml
, python
, tbbLatest
, tinyformat
, zlib
, pytestCheckHook
, enableEmbree ? false # The tests currently segfault with embree/tbb on
, enableVariants ? [ "scalar_rgb" ]
}:

buildPythonPackage rec {
  pname = "mitsuba3";
  version = "unstable-2023-11-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitsuba-renderer";
    repo = "mitsuba3";
    rev = "3549783b37a9d831997f9c39a2a8d5affcbf2c50";
    hash = "sha256-8iot1hivS01OvDI9VpxKBVhgvKw7XTjK1LPhv7kTVm4=";
    fetchSubmodules = true;
  };
  patches = [
    ./0001-cmake-try-find_package-first.patch
    ./0002-setup.py-try-PYTHONPATH-before-git-submodules.patch
    ./0003-python-tests-allow-running-with-mitsuba-in-site-pack.patch
    ./0004-mitsuba-s-__init__.py-don-t-check-the-expected-locat.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
    setuptools
    wheel
  ];

  buildInputs = [
    asmjit
    drjit-core
    fast-float
    libjpeg
    libpng
    nanothread
    openexr
    pugixml
    tbbLatest.dev
    tinyformat
    zlib

    pybind11
    # nanobind

    # find_library(... libatomic.so)
    stdenv.cc.cc.lib
  ] ++ lib.optionals enableEmbree [
    embree
  ];

  propagatedBuildInputs = [
    drjit
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  # CMAKE_ARGS for scikit-build.
  # Writable ~/.drjit, probably for the stub generation
  preConfigure = ''
    export CMAKE_ARGS=$cmakeFlags "''${cmakeFlagsArray[@]}"
    export HOME=$TMPDIR
  '';

  dontUseCmakeConfigure = true;
  # cmakeFlags = [ "-GNinja" ];

  cmakeFlags = [
    (lib.cmakeBool "MI_USE_SUBMODULES" false)
    (lib.cmakeBool "MI_ENABLE_EMBREE" enableEmbree)
    (lib.cmakeFeature "MI_DEFAULT_VARIANTS" (builtins.concatStringsSep ";" enableVariants))
  ];

  # The tests pick up mitsuba.test.util installed into the site-packages, and
  # then try to locate resources/data/* in one of the module's parent paths.
  # The "resources" are installed under a different name and only partially, so
  # we should use the directory from the source tree. We'd also probably have
  # to do something hacky if we wanted to use mitsuba.test.util from the source
  # tree because of the directory structure and the __path__ hacks
  preCheck = ''
    export MI_FIND_RESOURCE_ROOT=$PWD

    IFS=" " read -r -a disabledTestsEx <<< "$disabledTestsEx"
    pytestFlagsArray+=( "''${disabledTestsEx[@]/#/--deselect=}" )
  '';
  pytestFlagsArray = [
    "src/"
    "-m"
    ''"not slow"''
  ];
  disabledTestsEx = lib.optionals (!enableEmbree) [
    "src/shapes/tests/test_bsplinecurve.py::test01_create"
    "src/shapes/tests/test_bsplinecurve.py::test02_create_multiple_curves"
    "src/shapes/tests/test_bsplinecurve.py::test03_bbox"
    "src/shapes/tests/test_bsplinecurve.py::test05_ray_intersect"
    "src/shapes/tests/test_linearcurve.py::test01_create"
    "src/shapes/tests/test_linearcurve.py::test02_create_multiple_curves"
    "src/shapes/tests/test_linearcurve.py::test02_bbox"
    "src/shapes/tests/test_linearcurve.py::test04_ray_intersect"
    "src/shapes/tests/test_linearcurve.py::test08_instancing"
    "src/shapes/tests/test_sdfgrid.py::test01_create"
    "src/shapes/tests/test_sdfgrid.py::test02_bbox"
    "src/shapes/tests/test_sdfgrid.py::test03_parameters_changed"
    "src/shapes/tests/test_bsplinecurve.py::test02_create_multiple_curves"
    "src/shapes/tests/test_bsplinecurve.py::test03_bbox"
    "src/shapes/tests/test_bsplinecurve.py::test05_ray_intersect"
    "src/shapes/tests/test_linearcurve.py::test01_create"
    "src/shapes/tests/test_linearcurve.py::test02_create_multiple_curves"
    "src/shapes/tests/test_linearcurve.py::test02_bbox"
    "src/shapes/tests/test_linearcurve.py::test04_ray_intersect"
    "src/shapes/tests/test_linearcurve.py::test08_instancing"
    "src/shapes/tests/test_sdfgrid.py::test01_create"
    "src/shapes/tests/test_sdfgrid.py::test02_bbox"
    "src/shapes/tests/test_sdfgrid.py::test03_parameters_changed"
  ];
  postCheck = ''
    unset MI_FIND_RESOURCE_ROOT
  '';

  pythonImportsCheck = [ "mitsuba" ];

  meta = with lib; {
    description = "Mitsuba 3: A Retargetable Forward and Inverse Renderer";
    homepage = "https://github.com/mitsuba-renderer/mitsuba3/";
    license = licenses.bsd3;
    mainProgram = "mitsuba";
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
