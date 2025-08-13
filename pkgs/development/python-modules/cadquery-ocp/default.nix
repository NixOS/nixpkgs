{
  lib,
  pkgs,
  fetchFromGitHub,

  mkPythonMetaPackage,
  python,
  pythonImportsCheckHook,
  toPythonModule,

  llvmPackages_20,
  overrideLibcxx,
  cmake,
  ninja,
  yj,

  apple-sdk,
  fontconfig,
  freetype,
  libglvnd,
  libX11,
  nlohmann_json,
  opencascade-occt,
  pybind11,
  rapidjson,
  utf8cpp,
  vtk,
  xorgproto,
}:

let
  version = "7.8.1.2";

  # Upstream requires a minimum of LLVM 20.
  #
  # On Darwin, the default stdenv's libcxx comes from LLVM 19. To prevent compat
  # issues with deps, we need to use the same version in our LLVM 20 stdenv.
  llvmPackages = llvmPackages_20;
  stdenv =
    let
      stdenv' = llvmPackages.stdenv;
    in
    if stdenv'.cc.libcxx != null then overrideLibcxx stdenv' else stdenv';

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

  occt = opencascade-occt.override {
    inherit vtk;
    withVtk = true;
  };

  pythonBuildEnv = python.withPackages (
    ps: with ps; [
      # for dump_symbols.py
      lief
      logzero

      # for pywrap
      click
      path
      (libclang.override ({ inherit llvmPackages; }))
      toml
      pandas
      joblib
      tqdm
      jinja2
      toposort
      pyparsing
      pybind11
      schema
    ]
  );

  # Build sources for bindings. The generated sources will contain the CMake
  # project that builds the final Python module.
  ocp-sources = stdenv.mkDerivation {
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
      pkgs.jq
      yj

      llvmPackages.openmp
    ];

    buildInputs = [
      fontconfig
      freetype
      libglvnd
      libX11
      nlohmann_json
      occt
      pybind11
      rapidjson
      utf8cpp
      vtk
      xorgproto
    ];

    patches = [
      # backported CMakeLists and pywrap from 7.9, remove on version bump
      ./cmake-fixes-7_9.patch

      # Use CXX_IMPLICIT_INCLUDE_DIRECTORIES for header discovery on Darwin
      ./cmake-implicit-includes-darwin.patch
    ];

    # Apply patches for OCP settings
    #
    # Note: At the time of writing, only the combination of `jq` and `yj`
    # successfully roundtrips the OCP settings TOML file. `builtins.fromTOML`
    # and `writers.writeTOML` may also work, but their use in this context
    # requires IFD, which is not allowed in nixpkgs.
    postPatch =
      let
        overlay = import ./settings-overlay.nix { inherit lib stdenv apple-sdk; };
      in
      ''
        (cat ocp.toml | yj -tj; echo '${builtins.toJSON overlay}') |
        jq -s '.[0] * .[1]' | yj -jt > ocp.toml.1
        mv ocp.toml.1 ocp.toml
      '';

    preConfigure = ''
      cmakeFlagsArray+=(
        "-DN_PROC=$NIX_BUILD_CORES"
      )
    '';

    cmakeFlags = with llvmPackages; [
      (lib.cmakeFeature "Python_ROOT_DIR" "${pythonBuildEnv}")

      (lib.cmakeFeature "LLVM_DIR" "${lib.getDev libllvm}/lib/cmake/llvm")
      (lib.cmakeFeature "Clang_DIR" "${lib.getDev libclang}/lib/cmake/clang")
    ];
    dontUseCmakeBuildDir = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r OCP/* $out

      runHook postInstall
    '';
  };

  ocp = stdenv.mkDerivation (finalAttrs: {
    pname = "cadquery-ocp";
    inherit version;
    src = ocp-sources;

    nativeBuildInputs =
      ocp-sources.nativeBuildInputs
      ++ lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) pythonImportsCheckHook;
    inherit (ocp-sources) buildInputs;

    propagatedBuildInputs = [
      (mkPythonMetaPackage {
        inherit (finalAttrs) pname version meta;
      })
    ];

    env = {
      NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";
    };

    cmakeFlags = [ (lib.cmakeFeature "Python_ROOT_DIR" "${pythonBuildEnv}") ];

    separateDebugInfo = true;

    installPhase =
      let
        destDir = "$out/${python.sitePackages}";
      in
      ''
        runHook preInstall

        mkdir -p ${destDir}
        cp ./*.so ${destDir}

        runHook postInstall
      '';

    dependencies = [ vtk ];

    pythonImportsCheck = [
      "OCP"
      "OCP.gp"
    ];

    meta = {
      description = "Python wrapper for OCCT generated using pywrap";
      homepage = "https://github.com/CadQuery/OCP";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ tnytown ];
    };
  });
in
toPythonModule ocp
