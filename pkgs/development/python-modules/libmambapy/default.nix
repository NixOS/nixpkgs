{
  bzip2,
  cmake,
  curl,
  buildPythonPackage,
  fmt,
  lib,
  libmamba,
  libsolv,
  msgpack-c,
  ninja,
  nlohmann_json,
  pybind11,
  python,
  reproc,
  scikit-build-core,
  spdlog,
  tl-expected,
  yaml-cpp,
  zstd,
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
    bzip2
    curl
    fmt
    libsolv
    msgpack-c
    nlohmann_json
    reproc
    spdlog
    tl-expected
    yaml-cpp
    zstd
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
