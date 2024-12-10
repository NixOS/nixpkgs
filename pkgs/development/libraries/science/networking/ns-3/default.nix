{
  stdenv,
  breakpointHook,
  fetchFromGitLab,
  python,
  libxml2,
  sqlite,

  boost,
  gtk3-x11,
  root,
  glib,
  gsl,

  cmake,
  pkg-config,

  libpcap,

  jansson,

  harfbuzz,
  freetype,

  # for binding generation
  castxml ? null,
  cppyy ? null,

  # can take a long time, generates > 30000 images/graphs
  enableDoxygen ? false,

  # very long
  withManual ? false,
  doxygen ? null,
  graphviz ? null,
  imagemagick ? null,
  # for manual, tetex is used to get the eps2pdf binary
  # texlive to get latexmk. building manual still fails though
  dia,
  tetex ? null,
  ghostscript ? null,
  texliveMedium ? null,

  # generates python bindings
  pythonSupport ? true,
  ncurses ? null,

  lib,
}:

let
  pythonEnv = python.withPackages (
    ps:
    lib.optional withManual ps.sphinx
    ++ lib.optionals pythonSupport (
      with ps;
      [
        pybindgen
        pygccxml
        cppyy
      ]
    )
  );
in
stdenv.mkDerivation rec {
  pname = "ns-3";
  version = "39";

  src = fetchFromGitLab {
    owner = "nsnam";
    repo = "ns-3-dev";
    rev = "ns-3.${version}";
    sha256 = "sha256-2d8xCCfxRpcCZgt7ne17F7cUo/wIxLyvjQs3izNUnmY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    pythonEnv
  ];

  outputs = [ "out" ];

  # ncurses is a hidden dependency of waf when checking python
  buildInputs =
    lib.optionals pythonSupport [
      castxml
      ncurses
    ]
    ++ lib.optionals enableDoxygen [
      doxygen
      graphviz
      imagemagick
    ]
    ++ lib.optionals withManual [
      dia
      tetex
      ghostscript
      imagemagick
      texliveMedium
    ]
    ++ [
      libxml2
      pythonEnv
      sqlite.dev
      gsl
      boost
      root
      glib.out
      glib.dev
      libpcap
      gtk3-x11.dev
      harfbuzz
      freetype
      jansson
    ];

  propagatedBuildInputs = [ pythonEnv ];

  preConfigure = ''
     substituteInPlace src/tap-bridge/CMakeLists.txt \
       --replace '-DTAP_CREATOR="''${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/src/tap-bridge/' "-DTAP_CREATOR=\"$out/libexec/ns3/"

    substituteInPlace src/fd-net-device/CMakeLists.txt \
      --replace '-DRAW_SOCK_CREATOR="''${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/src/fd-net-device/' "-DRAW_SOCK_CREATOR=\"$out/libexec/ns3/"

    substituteInPlace src/fd-net-device/CMakeLists.txt \
      --replace '-DTAP_DEV_CREATOR="''${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/src/fd-net-device/' "-DTAP_DEV_CREATOR=\"$out/libexec/ns3/"
  '';

  doCheck = false;

  buildTargets =
    "build" + lib.optionalString enableDoxygen " doxygen" + lib.optionalString withManual "sphinx";

  # to prevent fatal error: 'backward_warning.h' file not found
  CXXFLAGS = "-D_GLIBCXX_PERMIT_BACKWARD_HASH";

  # Make generated python bindings discoverable in customized python environment
  passthru = {
    pythonModule = python;
  };

  cmakeFlags = [
    "-DPython3_LIBRARY_DIRS=${pythonEnv}/lib"
    "-DPython3_INCLUDE_DIRS=${pythonEnv}/include"
    "-DPython3_EXECUTABLE=${pythonEnv}/bin/python"
    "-DNS3_PYTHON_BINDINGS=ON"
    "-DNS3_DES_METRICS=ON"
    "-DNS3_BINDINGS_INSTALL_DIR=${pythonEnv.sitePackages}"
    "-DNS3_LOG=ON"
    "-DNS3_ASSERT=ON"
    "-DNS3_GTK3=ON"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ] ++ lib.optional doCheck "-DNS3_TESTS=ON";

  # strictoverflow prevents clang from discovering pyembed when bindings
  hardeningDisable = [
    "fortify"
    "strictoverflow"
  ];

  meta = with lib; {
    homepage = "http://www.nsnam.org";
    license = licenses.gpl3;
    description = "A discrete time event network simulator";
    platforms = with platforms; unix;
    maintainers = with maintainers; [
      teto
      rgrunbla
    ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = (stdenv.isDarwin && stdenv.isAarch64) || (stdenv.isLinux && stdenv.isAarch64);
  };
}
