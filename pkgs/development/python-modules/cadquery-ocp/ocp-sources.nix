{
  lib,
  writers,
  fetchFromGitHub,

  llvmPackages,
  cmake,
  ninja,

  apple-sdk,
  fontconfig,
  freetype,
  libglvnd,
  libx11,
  nlohmann_json,
  opencascade-occt_7_8_1,
  pybind11,
  rapidjson,
  utf8cpp,
  vtk,
  xorgproto,

  pythonBuildEnv,
}:
let
  version = "7.8.1.2";

  stdenv = llvmPackages.libcxxStdenv;

  srcs = {
    ocp = fetchFromGitHub {
      owner = "CadQuery";
      repo = "OCP";
      rev = version;
      hash = "sha256-vWAqCGgs7YnwHRhPAXkBQqCs+Y3zk4BMu1boZo3PLGA=";
      name = "ocp";
    };

    pywrap = fetchFromGitHub {
      owner = "CadQuery";
      repo = "pywrap";

      # revision used in OCP 7.9
      # remove this fetch when bumping OCP and use `fetchSubmodules` above
      rev = "7e08fe91a582533c0e668b90cc48ded726639094";
      hash = "sha256-Ju2CGJ0fAuh53xA7muaf1mAoqHUI5hc6VJEcjJVxxjU=";
      name = "pywrap";
    };
  };

  opencascade-occt' = opencascade-occt_7_8_1.override {
    inherit vtk;
    withVtk = true;
  };
in
stdenv.mkDerivation {
  pname = "ocp-sources";
  inherit version;

  srcs = [
    srcs.ocp
    srcs.pywrap
  ];

  sourceRoot = srcs.ocp.name;

  postUnpack = ''
    cp -rf ${srcs.pywrap.name} ${srcs.ocp.name}
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    fontconfig
    freetype
    libglvnd
    libx11
    nlohmann_json
    opencascade-occt'
    pybind11
    rapidjson
    utf8cpp
    vtk
    xorgproto

    llvmPackages.openmp
    llvmPackages.llvm
    llvmPackages.libclang
  ];

  patches = [
    # backported CMakeLists and pywrap from 7.9, remove on version bump
    ./cmake-fixes-7_9.patch

    # Use CXX_IMPLICIT_INCLUDE_DIRECTORIES for header discovery on Darwin
    ./cmake-implicit-includes-darwin.patch
  ];

  # Apply patches for OCP settings
  #
  # NOTE: ocp.toml comes from upstream and should be refreshed on version bumps.
  # We check it in to nixpkgs to avoid IFD.
  postPatch =
    let
      old = builtins.fromTOML (builtins.readFile ./ocp.toml);
      overlay = import ./settings-overlay.nix { inherit lib stdenv apple-sdk; };
      new = lib.recursiveUpdate old overlay;
    in
    ''
      cp ${writers.writeTOML "ocp.toml" new} ocp.toml
    '';

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DN_PROC=$NIX_BUILD_CORES"
    )
  '';

  cmakeFlags = [
    (lib.cmakeFeature "Python_ROOT_DIR" "${pythonBuildEnv}")
  ];
  dontUseCmakeBuildDir = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r OCP/* $out

    runHook postInstall
  '';
}
