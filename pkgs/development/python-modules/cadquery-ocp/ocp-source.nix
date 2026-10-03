{
  lib,
  llvmPackages,
  fetchFromGitHub,
  lief,
  click,
  path,
  libclang,
  toml,
  pandas,
  joblib,
  tqdm,
  jinja2,
  toposort,
  logzero,
  pyparsing,
  pybind11,
  schema,
  cmake,
  fmt,
  rapidjson,
  libGL,
  vtk,
  opencascade-occt,
}:
let
  opencascade-occt' = (
    opencascade-occt.override {
      inherit vtk;
      withVtk = true;
    }
  );
in
llvmPackages.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "ocp-source";
  version = "7.9.3.1";

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "OCP";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-TKvJ03WHVuUAMTHLr2KWjKU1rBoSOfpAIxjjpYKN2nQ=";
  };

  patches = [
    ./cmake-implicit-include-darwin.patch
    ./inhert-python-path.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      ''\'''${CLANG_INSTALL_PREFIX}/lib/clang/''${LLVM_VERSION_MAJOR}/include/' \
      '${lib.getLib llvmPackages.libclang}/lib/clang/''${LLVM_VERSION_MAJOR}/include/'
  '';

  nativeBuildInputs = [
    lief
    click
    path
    libclang
    toml
    pandas
    joblib
    tqdm
    jinja2
    toposort
    logzero
    pyparsing
    pybind11
    schema
    cmake
  ];

  buildInputs = [
    fmt
    rapidjson
    libGL
    vtk
    llvmPackages.libclang
    llvmPackages.llvm
    llvmPackages.openmp
    opencascade-occt'
  ];

  dontUseCmakeBuildDir = true;

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DN_PROC=$NIX_BUILD_CORES"
    )
  '';

  installPhase = ''
    mkdir $out
    cp OCP/* $out
  '';
})
