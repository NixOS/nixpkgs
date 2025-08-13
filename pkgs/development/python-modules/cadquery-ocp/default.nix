{
  lib,
  llvmPackages_15,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  setuptools,

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

  # the next version of OCP will compile on LLVM >= 16
  # https://github.com/CadQuery/OCP/issues/139
  llvmPackages = llvmPackages_15;
  inherit (llvmPackages) stdenv;

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
      hash = "sha256-kGBPhPqho5gz+Kod9Kx5VtXgZk1i0HHzT5NcDE7fRck=";

      fetchSubmodules = true;
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

  # patch OCP settings for macOS: libclang can't find headers without help
  ocpSettings =
    let
      inherit (stdenv) cc;
      patch = {
        OSX = lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
          prefix = "${apple-sdk.sdkroot}";
          includes = [
            "${lib.getDev cc.libcxx}/include/c++/v1"
            "${cc}/resource-root"
            "${lib.getLib cc.cc}/lib/clang/${cc.version}/include"
          ];
        };
      };
    in
    builtins.toJSON patch;

  # step 1/3: invoke cmake's configure step to trigger pybind
  ocp-pybound = stdenv.mkDerivation {
    pname = "pybound-ocp";
    inherit version;

    src = srcs.ocp;

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

    # Apply OCP settings patches and perform a few ad-hoc replacements:
    # - VTK_INCLUDE_DIR is broken and returns raw generator expressions
    # - inaccessible system include paths need to be removed
    # - CLANG_INSTALL_PREFIX needs to be manually set because nixpkgs clang puts
    #   the files we're interested in behind a different output
    # - add_subdirectory on the generated OCP sources results in an unnecessary
    #   reinvocation of project() and buggy behavior
    postPatch = ''
      (cat ocp.toml | yj -tj; echo '${ocpSettings}') |
        jq -s '.[0] * .[1]' | yj -jt > ocp.toml.1
      mv ocp.toml.1 ocp.toml

      substituteInPlace CMakeLists.txt \
        --replace-fail "\''${VTK_INCLUDE_DIR}" \
        "${lib.getDev vtk}/include/vtk" \
        --replace-fail "list( APPEND CXX_INCLUDES -i /opt/usr/local/include/c++/v1/ -i /opt/usr/local/include/ )" "" \
        --replace-fail "\''${CLANG_INSTALL_PREFIX}" \
        "${lib.getLib llvmPackages.libclang}" \
        --replace-fail "add_subdirectory( \''${CMAKE_SOURCE_DIR}/OCP )" ""
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

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ../OCP/* $out/

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
