{ stdenv
<<<<<<< HEAD
, breakpointHook
, fetchFromGitLab
, python
, libxml2
, sqlite

, boost
, gtk3-x11
, root
, glib
, gsl

, cmake
, pkg-config


, libpcap

, jansson

, harfbuzz
, freetype

  # for binding generation
, castxml ? null
, cppyy ? null

  # can take a long time, generates > 30000 images/graphs
, enableDoxygen ? false

  # very long
, withManual ? false
, doxygen ? null
, graphviz ? null
, imagemagick ? null
  # for manual, tetex is used to get the eps2pdf binary
  # texlive to get latexmk. building manual still fails though
, dia
, tetex ? null
, ghostscript ? null
, texlive ? null

  # generates python bindings
, pythonSupport ? true
, ncurses ? null

=======
, fetchFromGitLab
, python
, wafHook

# for binding generation
, castxml ? null

# can take a long time, generates > 30000 images/graphs
, enableDoxygen ? false

# e.g. "optimized" or "debug". If not set, use default one
, build_profile ? null

# --enable-examples
, withExamples ? false

# very long
, withManual ? false, doxygen ? null, graphviz ? null, imagemagick ? null
# for manual, tetex is used to get the eps2pdf binary
# texlive to get latexmk. building manual still fails though
, dia, tetex ? null, ghostscript ? null, texlive ? null

# generates python bindings
, pythonSupport ? false, ncurses ? null

# All modules can be enabled by choosing 'all_modules'.
# we include here the DCE mandatory ones
, modules ? [ "core" "network" "internet" "point-to-point" "point-to-point-layout" "fd-net-device" "netanim" ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, lib
}:

let
<<<<<<< HEAD
  pythonEnv = python.withPackages (ps:
    lib.optional withManual ps.sphinx
    ++ lib.optionals pythonSupport (with ps;[ pybindgen pygccxml cppyy])
=======
  pythonEnv = python.withPackages(ps:
    lib.optional withManual ps.sphinx
    ++ lib.optionals pythonSupport (with ps;[ pybindgen pygccxml ])
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  );
in
stdenv.mkDerivation rec {
  pname = "ns-3";
<<<<<<< HEAD
  version = "39";

  src = fetchFromGitLab {
    owner = "nsnam";
    repo = "ns-3-dev";
    rev = "ns-3.${version}";
    sha256 = "sha256-2d8xCCfxRpcCZgt7ne17F7cUo/wIxLyvjQs3izNUnmY=";
  };

  nativeBuildInputs = [ cmake pkg-config pythonEnv ];

  outputs = [ "out" ];
=======
  version = "35";

  src = fetchFromGitLab {
    owner = "nsnam";
    repo   = "ns-3-dev";
    rev    = "ns-3.${version}";
    sha256 = "sha256-3w+lCWWra9sndL8+vkGfH5plrDYYCMFi1PzwIVRku6I=";
  };

  nativeBuildInputs = [ wafHook python ];

  outputs = [ "out" ] ++ lib.optional pythonSupport "py";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # ncurses is a hidden dependency of waf when checking python
  buildInputs = lib.optionals pythonSupport [ castxml ncurses ]
    ++ lib.optionals enableDoxygen [ doxygen graphviz imagemagick ]
<<<<<<< HEAD
    ++ lib.optionals withManual [ dia tetex ghostscript imagemagick texlive.combined.scheme-medium ]
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
=======
    ++ lib.optionals withManual [ dia tetex ghostscript texlive.combined.scheme-medium ];

  propagatedBuildInputs = [ pythonEnv ];

  postPatch = ''
    patchShebangs doc/ns3_html_theme/get_version.sh
  '';

  wafConfigureFlags = with lib; [
      "--enable-modules=${concatStringsSep "," modules}"
      "--with-python=${pythonEnv.interpreter}"
  ]
  ++ optional (build_profile != null) "--build-profile=${build_profile}"
  ++ optional withExamples " --enable-examples "
  ++ optional doCheck " --enable-tests "
  ;

  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildTargets = "build"
    + lib.optionalString enableDoxygen " doxygen"
    + lib.optionalString withManual "sphinx";

  # to prevent fatal error: 'backward_warning.h' file not found
  CXXFLAGS = "-D_GLIBCXX_PERMIT_BACKWARD_HASH";

<<<<<<< HEAD
  # Make generated python bindings discoverable in customized python environment
  passthru = { pythonModule = python; };

  cmakeFlags = [
    "-DPython3_LIBRARY_DIRS=${pythonEnv}/lib"
    "-DPython3_INCLUDE_DIRS=${pythonEnv}/include"
    "-DPython3_EXECUTABLE=${pythonEnv}/bin/python"
    "-DNS3_PYTHON_BINDINGS=ON"
    "-DNS3_DES_METRICS=ON"
    "-DNS3_BINDINGS_INSTALL_DIR=lib/${pythonEnv.libPrefix}/site-packages"
    "-DNS3_LOG=ON"
    "-DNS3_ASSERT=ON"
    "-DNS3_GTK3=ON"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ]
    ++ lib.optional doCheck "-DNS3_TESTS=ON";

  # strictoverflow prevents clang from discovering pyembed when bindings
  hardeningDisable = [ "fortify" "strictoverflow" ];
=======
  postBuild = with lib; let flags = concatStringsSep ";" (
      optional enableDoxygen "./waf doxygen"
      ++ optional withManual "./waf sphinx"
    );
    in "${flags}"
  ;

  postInstall = ''
    moveToOutput "${pythonEnv.libPrefix}" "$py"
  '';

  # we need to specify the proper interpreter else ns3 can check against a
  # different version
  checkPhase =  ''
    ${pythonEnv.interpreter} ./test.py --nowaf
  '';

  # strictoverflow prevents clang from discovering pyembed when bindings
  hardeningDisable = [ "fortify" "strictoverflow"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "http://www.nsnam.org";
    license = licenses.gpl3;
    description = "A discrete time event network simulator";
    platforms = with platforms; unix;
    maintainers = with maintainers; [ teto rgrunbla ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = (stdenv.isDarwin && stdenv.isAarch64) || (stdenv.isLinux && stdenv.isAarch64);
  };
}
