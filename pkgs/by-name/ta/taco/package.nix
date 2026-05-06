{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  python3,
  llvmPackages,
  enablePython ? false,
}:

let
  pyEnv = python3.withPackages (
    p: with p; [
      numpy
      scipy
      distutils
    ]
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "taco";
  version = "0-unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "tensor-compiler";
    repo = "taco";
    rev = "0e79acb56cb5f3d1785179536256e206790b2a9e";
    fetchSubmodules = true;
    hash = "sha256-mdT6ZLxtJ7fqyjRqdWf6+RltvMy7YDr9AEnJtnaDmTw=";
  };

  src-new-pybind11 = python3.pkgs.pybind11.src;

  postPatch = ''
    rm -rf python_bindings/pybind11/*
    cp -r ${finalAttrs.src-new-pybind11}/* python_bindings/pybind11
    find python_bindings/pybind11 -exec chmod +w {} \;

    # CMake4 no longer support version < 3.5
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.4.0 FATAL_ERROR)" \
      "cmake_minimum_required(VERSION 3.5)"
    substituteInPlace apps/tensor_times_vector/CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8.12)" \
      "cmake_minimum_required(VERSION 3.5)"

    # Newer pybind11 typing wrappers require a single concrete lambda return type.
    substituteInPlace python_bindings/src/pytaco.cpp --replace-fail \
      'm.def("get_parallel_schedule", [](){' \
      'm.def("get_parallel_schedule", []() -> py::tuple {'
  '';

  # Remove test cases from cmake build as they violate modern C++ expectations
  patches = [ ./taco.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = lib.optional enablePython pyEnv;

  cmakeFlags = [
    "-DOPENMP=ON"
  ]
  ++ lib.optional enablePython "-DPYTHON=ON";

  postInstall = lib.strings.optionalString enablePython ''
    mkdir -p $out/${python3.sitePackages}
    cp -r lib/pytaco $out/${python3.sitePackages}/.
  '';

  # The standard CMake test suite fails a single test of the CLI interface.
  doCheck = false;

  # Cython somehow gets built with references to /build/.
  # However, the python module works flawlessly.
  dontFixup = enablePython;

  meta = {
    description = "Computes sparse tensor expressions on CPUs and GPUs";
    mainProgram = "taco";
    license = lib.licenses.mit;
    homepage = "https://github.com/tensor-compiler/taco";
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
