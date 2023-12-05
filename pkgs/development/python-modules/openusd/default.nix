{ buildPythonPackage
, fetchFromGitHub
, lib
, writeShellScriptBin
, cmake
, doxygen
, draco
, graphviz-nox
, ninja
, setuptools
, pyqt6
, pyopengl
, jinja2
, pyside6
, boost
, numpy
, git
, tbb
, opensubdiv
, openimageio
, opencolorio
, osl
, ptex
, embree
, alembic
, openexr
, flex
, bison
, qt6
, python
}:
let
  # Matches the pyside6-uic implementation
  # https://code.qt.io/cgit/pyside/pyside-setup.git/tree/sources/pyside-tools/pyside_tool.py?id=e501cad66146a49c7a259579c7bb94bc93a67a08#n82
  pyside-tools-uic = writeShellScriptBin "pyside6-uic" ''
    exec ${qt6.qtbase}/libexec/uic -g python "$@"
  '';
in
buildPythonPackage rec {
  pname = "OpenUSD";
  version = "23.11";
  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5zQrfB14kXs75WbL3s4eyhxELglhLNxU2L2aVXiyVjg=";
  };

  outputs = ["out" "doc"];

  format = "other";

  propagatedBuildInputs = [
    setuptools
    pyqt6
    pyopengl
    jinja2
    pyside6
    pyside-tools-uic
    boost
    numpy
  ];

  cmakeFlags = [
    "-DPXR_BUILD_EXAMPLES=OFF"
    "-DPXR_BUILD_TUTORIALS=OFF"
    "-DPXR_BUILD_USD_TOOLS=ON"
    "-DPXR_BUILD_IMAGING=ON"
    "-DPXR_BUILD_USD_IMAGING=ON"
    "-DPXR_BUILD_USDVIEW=ON"
    "-DPXR_BUILD_DOCUMENTATION=ON"
    "-DPXR_BUILD_PYTHON_DOCUMENTATION=ON"
    "-DPXR_BUILD_EMBREE_PLUGIN=ON"
    "-DPXR_BUILD_ALEMBIC_PLUGIN=ON"
    "-DPXR_ENABLE_OSL_SUPPORT=ON"
    "-DPXR_BUILD_DRACO_PLUGIN=ON"
    "-DPXR_BUILD_MONOLITHIC=ON" # Seems to be commonly linked to monolithically
  ];

  nativeBuildInputs = [
    cmake
    ninja
    git
    qt6.wrapQtAppsHook
    doxygen
    graphviz-nox
  ];
  buildInputs = [
    tbb
    opensubdiv
    openimageio
    opencolorio
    osl
    ptex
    embree
    alembic.dev
    openexr
    flex
    bison
    boost
    draco
    qt6.qtbase
    qt6.qtwayland
  ];

  pythonImportsCheck = [ "pxr" "pxr.Usd" ];

  postInstall = ''
    # Make python lib properly accessible
    target_dir=$out/${python.sitePackages}
    mkdir -p $(dirname $target_dir)
    mv $out/lib/python $target_dir

    mv $out/docs $doc

    rm $out/share -r # only examples
    rm $out/tests -r
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
