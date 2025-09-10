{
  alembic,
  bison,
  boost,
  buildPythonPackage,
  cmake,
  distutils,
  doxygen,
  draco,
  embree,
  fetchFromGitHub,
  fetchpatch,
  flex,
  git,
  graphviz-nox,
  imath,
  jinja2,
  lib,
  libGL,
  libX11,
  libXt,
  materialx,
  ninja,
  numpy,
  opencolorio,
  openimageio,
  opensubdiv,
  osl,
  ptex,
  pyopengl,
  pyqt6,
  pyside6,
  python,
  qt6,
  setuptools,
  tbb,
  withDocs ? false,
  withOsl ? true,
  withTools ? false,
  withUsdView ? false,
  writeShellScriptBin,
}:

let
  # Matches the pyside6-uic implementation
  # https://code.qt.io/cgit/pyside/pyside-setup.git/tree/sources/pyside-tools/pyside_tool.py?id=e501cad66146a49c7a259579c7bb94bc93a67a08#n82
  pyside-tools-uic = writeShellScriptBin "pyside6-uic" ''
    exec ${qt6.qtbase}/libexec/uic -g python "$@"
  '';
in

buildPythonPackage rec {
  pname = "openusd";
  version = "25.05.01";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenUSD";
    tag = "v${version}";
    hash = "sha256-gxikEC4MqTkhgYaRsCVYtS/VmXClSaCMdzpQ0LmiR7Q=";
  };

  stdenv = python.stdenv;

  outputs = [ "out" ] ++ lib.optional withDocs "doc";

  patches = [
    (fetchpatch {
      name = "port-to-embree-4.patch";
      # https://github.com/PixarAnimationStudios/OpenUSD/pull/2266
      url = "https://github.com/PixarAnimationStudios/OpenUSD/commit/9ea3bc1ab550ec46c426dab04292d9667ccd2518.patch?full_index=1";
      hash = "sha256-QjA3kjUDsSleUr+S/bQLb+QK723SNFvnmRPT+ojjgq8=";
    })
    (fetchpatch {
      # https://github.com/PixarAnimationStudios/OpenUSD/pull/3648
      name = "propagate-dependencies-opengl.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/usd/-/raw/41469f20113d3550c5b42e67d1139dedc1062b8c/usd-find-dependency-OpenGL.patch?full_index=1";
      hash = "sha256-aUWGKn365qov0ttGOq5GgNxYGIGZ4DfmeMJfakbOugQ=";
    })
  ];

  env.OSL_LOCATION = "${osl}";

  cmakeFlags = [
    "-DPXR_BUILD_ALEMBIC_PLUGIN=ON"
    "-DPXR_BUILD_DRACO_PLUGIN=ON"
    "-DPXR_BUILD_EMBREE_PLUGIN=ON"
    "-DPXR_BUILD_EXAMPLES=OFF"
    "-DPXR_BUILD_IMAGING=ON"
    "-DPXR_BUILD_MONOLITHIC=ON" # Seems to be commonly linked to monolithically
    "-DPXR_BUILD_TESTS=OFF"
    "-DPXR_BUILD_TUTORIALS=OFF"
    "-DPXR_BUILD_USD_IMAGING=ON"
    "-DPYSIDE_BIN_DIR=${pyside-tools-uic}/bin"
    (lib.cmakeBool "PXR_BUILD_DOCUMENTATION" withDocs)
    (lib.cmakeBool "PXR_BUILD_PYTHON_DOCUMENTATION" withDocs)
    (lib.cmakeBool "PXR_BUILD_USDVIEW" withUsdView)
    (lib.cmakeBool "PXR_BUILD_USD_TOOLS" withTools)
    (lib.cmakeBool "PXR_ENABLE_MATERIALX_SUPPORT" true)
    (lib.cmakeBool "PXR_ENABLE_OSL_SUPPORT" (!stdenv.hostPlatform.isDarwin && withOsl))
  ];

  nativeBuildInputs = [
    cmake
    ninja
    setuptools
    opensubdiv.dev
    opensubdiv.static
  ]
  ++ lib.optionals withDocs [
    git
    graphviz-nox
    doxygen
  ]
  ++ lib.optionals withUsdView [ qt6.wrapQtAppsHook ];

  buildInputs = [
    alembic.dev
    bison
    draco
    embree
    flex
    imath
    materialx
    opencolorio
    openimageio
    ptex
    tbb
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXt
  ]
  ++ lib.optionals withOsl [ osl ]
  ++ lib.optionals withUsdView [ qt6.qtbase ]
  ++ lib.optionals (withUsdView && stdenv.hostPlatform.isLinux) [ qt6.qtwayland ];

  propagatedBuildInputs = [
    boost
    jinja2
    numpy
    opensubdiv
    pyopengl
    distutils
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
  ]
  ++ lib.optionals (withTools || withUsdView) [
    pyside-tools-uic
    pyside6
  ]
  ++ lib.optionals withUsdView [ pyqt6 ];

  pythonImportsCheck = [
    "pxr"
    "pxr.Usd"
  ];

  postInstall = ''
    # Make python lib properly accessible
    target_dir=$out/${python.sitePackages}
    mkdir -p $(dirname $target_dir)
    mv $out/lib/python $target_dir
  ''
  + lib.optionalString withDocs ''
    mv $out/docs $doc
  '';

  meta = {
    description = "Universal Scene Description";
    longDescription = ''
      Universal Scene Description (USD) is an efficient, scalable system
      for authoring, reading, and streaming time-sampled scene description
      for interchange between graphics applications.
    '';
    homepage = "https://openusd.org/";
    changelog = "https://github.com/PixarAnimationStudios/OpenUSD/${src.tag}/CHANGELOG.md";
    license = lib.licenses.tost;
    maintainers = with lib.maintainers; [
      shaddydc
      gador
    ];
  };
}
