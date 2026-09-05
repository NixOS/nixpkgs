{
  lib,
  buildPythonPackage,
  stdenv,
  fetchFromGitHub,
  isPy3k,
  python,
  llvmPackages_20,

  # build
  cmake,
  mpi,
  ninja,
  pybind11,

  # dependencies
  fmt,
  fontconfig,
  freeglut,
  libGL,
  libGLU,
  opencascade-occt,
  rapidjson,
  vtk,
}:
let
  llvm = llvmPackages_20.llvm;
  clang = llvmPackages_20.clang;
  inherit (llvmPackages_20) libclang;

  pythonEnv = python.withPackages (
    ps:
    with ps;
    [
      click
      jinja2
      joblib
      logzero
      lief
      pandas
      path
      pybind11
      pyparsing
      schema
      toml
      toposort
      tqdm
    ]
    ++ [ (ps.clang.override { llvmPackages = llvmPackages_20; }) ]
  );

  version = "7.9.3.1.1";

  ocp-src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "OCP";
    rev = version;
    hash = "sha256-TKvJ03WHVuUAMTHLr2KWjKU1rBoSOfpAIxjjpYKN2nQ=";
    fetchSubmodules = true;
  };

  ocp-stubs = stdenv.mkDerivation {
    pname = "cadquery-ocp-stubs";
    inherit version;
    src = ocp-src;
    __structuredAttrs = true;

    nativeBuildInputs = [
      cmake
      ninja
      clang
      pythonEnv
    ];

    buildInputs = [
      fontconfig
      freeglut
      libGL
      libGLU
      llvm
      clang
      libclang
      (opencascade-occt.override { withVtk = true; })
      rapidjson
      vtk
    ];

    patches = [ ./ocp-cmake.patch ];

    postPatch = ''
      sed -i 's|-Wno-deprecated-declarations|-Wno-deprecated-declarations",\n        "-Wno-invalid-constexpr|' pywrap/bindgen/translation_unit.py
    '';

    dontFixup = true;

    configurePhase = ''
      CLANG_RESOURCE_DIR=$(${clang}/bin/clang -print-resource-dir)
      cmake -G Ninja -S . -B build_dir \
        -DN_PROC=$NIX_BUILD_CORES \
        -DCLANG_INC_DIR="$CLANG_RESOURCE_DIR/include" \
        -DPython_ROOT_DIR="${pythonEnv}"
    '';

    buildPhase = ''
      cmake --build build_dir --target pywrap
    '';

    installPhase = ''
      mkdir -p $out
      cp -r build_dir/OCP/* $out/
    '';
  };
in
buildPythonPackage (finalAttrs: {
  pname = "cadquery-ocp";
  inherit version;
  pyproject = false;
  disabled = !isPy3k;
  __structuredAttrs = true;

  src = ocp-stubs;

  dontUnpack = true;

  postPatch = ''
    cp -r $src/* .
    chmod -R u+w .
    sed -i '/WrappingPythonCore/d' CMakeLists.txt
    sed -i "/Python::Module/a\  ${fmt}/lib/libfmt.so" CMakeLists.txt
    VTK_WRAP=$(echo ${vtk}/lib/libvtkWrappingPythonCore*.so)
    sed -i "/Python::Module/a\  $VTK_WRAP" CMakeLists.txt
  '';

  nativeBuildInputs = [
    clang
    cmake
    llvm
    mpi
    ninja
    pybind11
  ];

  buildInputs = [
    fmt
    fontconfig
    freeglut
    libGL
    libGLU
    (opencascade-occt.override { withVtk = true; })
    rapidjson
    vtk
  ];

  installPhase = ''
    runHook preInstall

    install -D *.so -t $out/${python.sitePackages}

    runHook postInstall
  '';

  pythonImportsCheck = [ "OCP" ];

  meta = {
    description = "Python wrapper for OpenCASCADE generated using pywrap (CadQuery OCP)";
    homepage = "https://github.com/CadQuery/OCP";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
