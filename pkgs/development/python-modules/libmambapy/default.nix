{
  lib,
  python,
  buildPythonPackage,
  cmake,
  ninja,
  libmamba,
  pybind11,
  scikit-build-core,
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
}:

buildPythonPackage rec {
  pname = "libmambapy";
  pyproject = true;

  inherit (libmamba) version src;

  sourceRoot = "${src.name}/libmambapy";

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    (libmamba.override { python3 = python; })
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

  pythonImportsCheck = [
    "libmambapy"
    "libmambapy.bindings"
  ];

  meta = {
    changelog = "https://github.com/mamba-org/mamba/blob/${src.tag}/libmambapy/CHANGELOG.md";
    description = "Python library for the fast Cross-Platform Package Manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
