{
  lib,
  llvmPackages_20,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  setuptools,
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
  tbb_2021,
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
    build-system = fetchFromGitHub {
      owner = "CadQuery";
      repo = "ocp-build-system";
      rev = "v7.8.1.0";
      hash = "sha256-GEWK6ZOi9PzlM8CDEdUFmtOwBE5Qaey73TSH8sKW8fw=";
    };

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

  ocpSettings = builtins.toJSON {
    # macOS: remove hardcoded include paths used upstream
    OSX = lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
      prefix = "${apple-sdk.sdkroot}";
      includes = [ ];
    };

    # backports from 7.9, remove after bumping version
    exclude_namespaces = [
      "std"
      "opencascade"
      "IMeshData"
      "IVtkTools"
      "BVH"
      "OpenGl"
      "OpenGl_HashMapInitializer"
      "Graphic3d_TransformUtils"
    ];

    byref_types_smart_ptr = [
      "opencascade::handle"
      "handle"
      "Handle"
    ];

    Modules = {
      Standard.exclude_methods = [
        "Standard_Dump::DumpCharacterValues"
        "Standard_Dump::DumpRealValues"
        "Standard_CLocaleSentry::GetCLocale"
        "Standard_Dump::InitRealValues"
        "Standard_ErrorHandler::Label"
      ];

      NCollection.exclude_class_template_methods = [
        ".*::begin"
        ".*::end"
        ".*::cbegin"
        ".*::cend"
      ];

      AdvApp2Var.exclude_classes = [ "AdvApp2Var_MathBase" ];
    };
  };

  # step 1/3: invoke cmake's configure step to trigger pybind
  ocp-pybound = stdenv.mkDerivation {
    pname = "pybound-ocp";
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

      # yq is a wrapper around jq that converts to and from toml, but for some
      # reason it barfs when roundtripping ocp.toml. we use the yj tool to
      # convert between json and toml separately.
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
      tbb_2021
      utf8cpp
      vtk
      xorgproto
    ];

    dontWrapQtApps = true;

    patches = [
      # backported CMakeLists and pywrap from 7.9, remove on version bump
      ./cmake-fixes-7_9.patch

      # Use CXX_IMPLICIT_INCLUDE_DIRECTORIES for header discovery on Darwin
      ./cmake-implicit-includes-darwin.patch
    ];

    # Apply patches for OCP settings
    postPatch = ''
      (cat ocp.toml | yj -tj; echo '${ocpSettings}') |
        jq -s '.[0] * .[1]' | yj -jt > ocp.toml.1
      mv ocp.toml.1 ocp.toml
    '';

    preConfigure =
      let
        tag =
          if stdenv.isLinux then
            "linux"
          else if stdenv.isDarwin then
            "mac"
          else
            throw "Unsupported OS";
      in
      ''
        cmakeFlagsArray+=(
          "-DN_PROC=$NIX_BUILD_CORES"
        )

        mkdir -p build
        cp dump_symbols.py build
        ln -s build/symbols_mangled_${tag}.dat
      '';

    cmakeFlags = with llvmPackages; [
      (lib.cmakeFeature "Python_ROOT_DIR" "${pythonBuildEnv}")

      (lib.cmakeFeature "LLVM_DIR" "${lib.getDev libllvm}/lib/cmake/llvm")
      (lib.cmakeFeature "Clang_DIR" "${lib.getDev libclang}/lib/cmake/clang")
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r OCP/* $out/

      runHook postInstall
    '';
  };

  # step 2/3: build the bound OCP sources
  ocp-natives = stdenv.mkDerivation {
    pname = "ocp-natives";
    inherit version;
    src = ocp-pybound;

    inherit (ocp-pybound) nativeBuildInputs buildInputs;

    env = {
      NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";
    };

    cmakeFlags = [ (lib.cmakeFeature "Python_ROOT_DIR" "${pythonBuildEnv}") ];

    separateDebugInfo = true;
    # vtk uses qtbase so we're forced to specify wrapping behavior
    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp ./*.so $out/

      runHook postInstall
    '';
  };

  # step 3/3: package the built OCP modules
in
buildPythonPackage {
  pname = "OCP";
  inherit version;
  src = srcs.build-system;
  sourceRoot = "${srcs.build-system.name}/pypi";

  pyproject = true;
  build-system = [ setuptools ];

  prePatch = ''
    mkdir OCP
    cp ${ocp-natives}/*.so OCP
    ln -s OCP/*.so .
    python ocp-tree.py
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
}
