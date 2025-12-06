{
  lib,
  buildPythonPackage,
  cbor2,
  docopt,
  fetchFromGitHub,
  fetchpatch2,
  jsonconversion,
  pytestCheckHook,
  pytest_7,
  setuptools,
  six,
  tabulate,
  cmake,
}:

buildPythonPackage rec {
  pname = "amazon-ion";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amazon-ion";
    repo = "ion-python";
    tag = "v${version}";
    # Test vectors require git submodule
    fetchSubmodules = true;
    hash = "sha256-ZnslVmXE2YvTAkpfw2lbpB+uF85n/CvA22htO/Y7yWk=";
  };

  patches = [
    # backport changes that adapt code to more strict compilers
    (fetchpatch2 {
      name = "46aebb0-Address-incompatible-pointer-errors.patch";
      url = "https://github.com/amazon-ion/ion-c/commit/46aebb0b650a4cf61425ef1a8e78e2443023e853.patch?full_index=1";
      hash = "sha256-5qzSbZV9Oe5soJzkyCtVtWejedLEjAz7yuVotATPmbs=";
      stripLen = 1;
      extraPrefix = "ion-c/";
    })
  ];

  CMAKE_FLAGS = "-DCMAKE_SKIP_BUILD_RPATH=ON";

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""

    # Ion C building is in _download_ion_c() which will try to remove sources and re-download
    substituteInPlace install.py \
      --replace-warn "isdir(_CURRENT_ION_C_DIR)" "False"
    substituteInPlace install.py \
      --replace-warn "check_call(['git'" "check_call(['true'"

    # Patch Ion-C version detection.
    # Parameters based on commit pointed from ion-python-0.13.0.
    #  10 commits from tag matching version in project file
    #  4 first hex digits of hash
    # https://github.com/amazon-ion/ion-c/compare/v1.1.2...6d4de4150fe162dde3fad55cefee8d3ec64fb974
    substituteInPlace ion-c/cmake/VersionHeader.cmake \
      --replace-warn 'set(IONC_FULL_VERSION "''${CMAKE_PROJECT_VERSION}")' \
                     'set(IONC_FULL_VERSION "v1.1.2-10-g6d4d")'
  '';

  build-system = [
    setuptools
    cmake
  ];

  dontUseCmakeConfigure = true; # CMake invoked by install.py

  dependencies = [
    jsonconversion
    six
  ];

  nativeCheckInputs = [
    cbor2
    docopt
    (pytestCheckHook.override { pytest = pytest_7; })
    tabulate
  ];

  disabledTests = [
    # ValueError: Exceeds the limit (4300) for integer string conversion
    "test_roundtrips"
  ];

  disabledTestPaths = [
    # Exclude benchmarks
    "tests/test_benchmark_cli.py"
  ];

  pythonImportsCheck = [
    "amazon.ion"
    "amazon.ion.ionc" # C extension module for speedup
  ];

  meta = with lib; {
    description = "Python implementation of Amazon Ion";
    homepage = "https://github.com/amazon-ion/ion-python";
    changelog = "https://github.com/amazon-ion/ion-python/releases/tag/${src.tag}";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
