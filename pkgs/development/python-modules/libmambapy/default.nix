{
  lib,
  fetchFromGitHub,
  pythonPackages,
  buildPythonPackage,
  cmake,
  ninja,
  libmamba,
  pybind11,
  setuptools,
  scikit-build,
  fmt,
  spdlog,
  tl-expected,
  nlohmann_json,
  yaml-cpp,
  reproc,
  libsolv,
  curl,
  zstd,
  bzip2,
  wheel,
}:

buildPythonPackage rec {
  pname = "libmambapy";
  pyproject = true;

  inherit (libmamba) version src;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=deprecated-declarations"
    ];
  };

  buildInputs = [
    (libmamba.override { python3Packages = pythonPackages; })
    curl
    zstd
    bzip2
    spdlog
    fmt
    tl-expected
    nlohmann_json
    yaml-cpp
    reproc
    libsolv
  ];

  dependencies = [
    scikit-build
    pybind11
  ];

  build-system = [
    setuptools
    wheel
  ];

  # patch needed to fix setuptools errors
  # see these for reference
  # https://stackoverflow.com/questions/72294299/multiple-top-level-packages-discovered-in-a-flat-layout
  # https://github.com/pypa/setuptools/issues/3197#issuecomment-1078770109
  postPatch = ''
    substituteInPlace libmambapy/setup.py --replace-warn  "setuptools.setup()" "setuptools.setup(py_modules=[])"
  '';

  cmakeFlags = [
    "-GNinja"
    (lib.cmakeBool "BUILD_LIBMAMBAPY" true)
  ];

  buildPhase = ''
    ninjaBuildPhase
    cp -r libmambapy ../libmambapy
    cd ../libmambapy
    pypaBuildPhase
  '';

  pythonImportsCheck = [
    "libmambapy"
    "libmambapy.bindings"
  ];

  meta = {
    description = "Python library for the fast Cross-Platform Package Manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
