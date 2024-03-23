{
  alembic,
  bison,
  boost,
  buildPythonPackage,
  cmake,
  darwin,
  doxygen,
  draco,
  embree,
  fetchFromGitHub,
  flex,
  git,
  graphviz-nox,
  imath,
  jinja2,
  lib,
  libGL,
  libX11,
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
  version = "23.11";

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenUSD";
    rev = "refs/tags/v${version}";
    hash = "sha256-5zQrfB14kXs75WbL3s4eyhxELglhLNxU2L2aVXiyVjg=";
  };

  stdenv = if python.stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else python.stdenv;

  outputs = [ "out" ] ++ lib.optional withDocs "doc";

  format = "other";

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
    (lib.cmakeBool "PXR_BUILD_DOCUMENTATION" withDocs)
    (lib.cmakeBool "PXR_BUILD_PYTHON_DOCUMENTATION" withDocs)
    (lib.cmakeBool "PXR_BUILD_USDVIEW" withUsdView)
    (lib.cmakeBool "PXR_BUILD_USD_TOOLS" withTools)
    (lib.cmakeBool "PXR_ENABLE_OSL_SUPPORT" (!stdenv.isDarwin && withOsl))
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
      boost
      draco
      embree
      flex
      imath
      opencolorio
      openimageio
      opensubdiv
      ptex
      tbb
    ]
    ++ lib.optionals stdenv.isLinux [
      libGL
      libX11
    ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [ Cocoa ])
    ++ lib.optionals withOsl [ osl ]
    ++ lib.optionals withUsdView [ qt6.qtbase ]
    ++ lib.optionals (withUsdView && stdenv.isLinux) [
      qt6.qtbase
      qt6.qtwayland
    ];

  propagatedBuildInputs =
    [
      boost
      jinja2
      numpy
      pyopengl
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
    ''
    + ''
      rm $out/share -r # only examples
    '';

  meta = {
    description = "Universal Scene Description";
    longDescription = ''
      Universal Scene Description (USD) is an efficient, scalable system
      for authoring, reading, and streaming time-sampled scene description
      for interchange between graphics applications.
    '';
    homepage = "https://openusd.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shaddydc ];
  };
}
