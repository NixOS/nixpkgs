{
  alembic,
  bison,
  boost,
  buildPythonPackage,
  cmake,
  darwin,
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
  version = "24.11";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenUSD";
    tag = "v${version}";
    hash = "sha256-ugTb28DAn8D3URxCyGeptf7F3YpL7bX4++lyVN+apas=";
  };

  stdenv = python.stdenv;

  outputs = [ "out" ] ++ lib.optional withDocs "doc";

  patches = [
    (fetchpatch {
      name = "port-to-embree-4.patch";
      # https://github.com/PixarAnimationStudios/OpenUSD/pull/2266
      url = "https://github.com/PixarAnimationStudios/OpenUSD/commit/a07a6b4d1da19bfc499db49641d74fb7c1a71e9b.patch?full_index=1";
      hash = "sha256-Gww6Ll2nKwpcxMY9lnf5BZ3eqUWz1rik9P3mPKDOf+Y=";
    })
    # https://github.com/PixarAnimationStudios/OpenUSD/issues/3442
    # https://github.com/PixarAnimationStudios/OpenUSD/pull/3434 commit 1
    (fetchpatch {
      name = "explicitly-adding-template-keyword.patch";
      url = "https://github.com/PixarAnimationStudios/OpenUSD/commit/274cf7c6fe1c121d095acd38dd1a33214e0c8448.patch?full_index=1";
      hash = "sha256-nlw7o2jVWV9f1Lzl32UXcRVXcWnfyMNv9Mp4SVgFvyw=";
    })
    # https://github.com/PixarAnimationStudios/OpenUSD/pull/3434 commit 2
    (fetchpatch {
      name = "fix-removes-unused-path.patch";
      url = "https://github.com/PixarAnimationStudios/OpenUSD/commit/5a6437e44269534bfde0c35cc2c7bdef087b70e8.patch?full_index=1";
      hash = "sha256-X2v14U0pJjd4IMD8viXK2/onVFqUabJTXwDGRFKDZ+g=";
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

  nativeBuildInputs =
    [
      cmake
      ninja
      setuptools
    ]
    ++ lib.optionals withDocs [
      git
      graphviz-nox
      doxygen
    ]
    ++ lib.optionals withUsdView [ qt6.wrapQtAppsHook ];

  buildInputs =
    [
      alembic.dev
      bison
      draco
      embree
      flex
      imath
      materialx
      opencolorio
      openimageio
      opensubdiv
      ptex
      tbb
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libGL
      libX11
      libXt
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk_11_0.frameworks; [ Cocoa ])
    ++ lib.optionals withOsl [ osl ]
    ++ lib.optionals withUsdView [ qt6.qtbase ]
    ++ lib.optionals (withUsdView && stdenv.hostPlatform.isLinux) [
      qt6.qtbase
      qt6.qtwayland
    ];

  propagatedBuildInputs =
    [
      boost
      jinja2
      numpy
      pyopengl
      distutils
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

  postInstall =
    ''
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
    license = lib.licenses.tost;
    maintainers = with lib.maintainers; [
      shaddydc
      gador
    ];
  };
}
