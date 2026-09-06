{
  buildPythonPackage,
  lib,
  fetchurl,
  stdenv,

  boost191,
  cairomm,
  cgal,
  expat,
  fontconfig,
  gobject-introspection,
  graphviz,
  gtk3,
  llvmPackages,
  matplotlib,
  mpfr,
  numpy,
  pkg-config,
  pycairo,
  pygobject3,
  python,
  scipy,
  zstandard,

  writableTmpDirAsHomeHook,

  gitUpdater,
}:

let
  boost' = boost191.override {
    enablePython = true;
    inherit python;
  };
in
buildPythonPackage (finalAttrs: {
  pname = "graph-tool";
  version = "3.6";
  pyproject = false;

  strictDeps = true;

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${finalAttrs.version}.tar.bz2";
    hash = "sha256-KFKitvz3zFEQAi8hkvIBC0c5QTRmOJRamdV0cyMbejU=";
  };

  postPatch =
    # remove error messages about tput during build process without adding ncurses
    ''
      substituteInPlace configure \
        --replace-fail 'tput setaf $1' : \
        --replace-fail 'tput sgr0' :
    ''
    +
    # hardcode path to graphviz library to avoid find_library, which would require setting LD_LIBRARY_PATH
    ''
      substituteInPlace src/graph_tool/draw/graphviz_draw.py \
        --replace-fail \
          'ctypes.util.find_library("gvc")' \
          '"${lib.getLib graphviz}/lib/libgvc${stdenv.hostPlatform.extensions.sharedLibrary}"'
    '';

  configureFlags =
    lib.mapAttrsToList (lib.withFeatureAs true) {
      boost-libdir = "${lib.getLib boost'}/lib";
      cgal = lib.getDev cgal;
      python-module-path = "$(out)/${python.sitePackages}";
    }
    ++ [
      # CXXFLAGS defaults to "-g -O2", if unset.
      # "-g" produces debugging information, which significantly increases
      # resource requirements during compilation, but is not necessary as we
      # subsequently strip the binaries.
      # "-ftemplate-backtrace-limit=1" reduces the number of template
      # instantiation notes per warning in order to reduce the log file size.
      # "-O3" is also used by upstream.
      "CXXFLAGS=-ftemplate-backtrace-limit=1 -O3"
    ]
    ++
      lib.optionals stdenv.cc.isGNU
        # enable GCC's link-time optimizer in order to reduce compilation time and memory usage during compilation
        # https://graph-tool.skewed.de/installation.html#memory-requirements-for-compilation
        # https://git.skewed.de/count0/graph-tool/-/issues/798#note_5626
        [ "MOD_CXXFLAGS=-flto" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  # https://graph-tool.skewed.de/installation.html#manual-compilation
  buildInputs = [
    boost'
    cairomm
    cgal
    expat
    mpfr
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  dependencies = [
    gtk3
    matplotlib
    numpy
    pycairo
    pygobject3
    scipy
    zstandard
  ];

  propagatedNativeBuildInputs = [ gobject-introspection ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  preInstallCheck =
    # avoid warnings about Matplotlib and Fontconfig configuration issues
    ''
      export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
    '';

  pythonImportsCheck = [ "graph_tool.all" ];

  passthru.updateScript = gitUpdater {
    url = "https://git.skewed.de/count0/graph-tool";
    rev-prefix = "release-";
  };

  meta = {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage = "https://graph-tool.skewed.de";
    changelog = "https://git.skewed.de/count0/graph-tool/commits/release-${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.mjoerg ];
  };
})
