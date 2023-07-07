{ stdenv
, fetchFromGitLab
, python
, autoPatchelfHook
, breakpointHook
, libxml2
, sqlite
, dpdk
, openssl
, gsl
, libnl
, sphinx
, boost
, gtk3-x11
, root
, glib
, libpcap
, libelf
, cmake
, pkg-config
, jansson
, pcre2
  # for binding generation
, castxml ? null

  # can take a long time, generates > 30000 images/graphs
, enableDoxygen ? false

  # e.g. "optimized" or "debug". If not set, use default one
, build_profile ? null

  # --enable-examples
, withExamples ? false

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

  # All modules can be enabled by choosing 'all_modules'.
  # we include here the DCE mandatory ones
, modules ? [ "core" "network" "internet" "point-to-point" "point-to-point-layout" "fd-net-device" "netanim" ]
, lib
}:

let
  pythonEnv = python.withPackages (ps:
    lib.optional withManual ps.sphinx
    ++ lib.optionals pythonSupport (with ps;[ pybindgen pygccxml ])
  );
in
stdenv.mkDerivation rec {
  pname = "ns-3";
  version = "38";

  src = fetchFromGitLab {
    owner = "nsnam";
    repo = "ns-3-dev";
    rev = "ns-3.${version}";
    sha256 = "sha256-3t1Ghdp2jf2op567+YpBP/EGDZjg/tAc7+QNUDnfFPg=";
  };

  nativeBuildInputs = [ cmake pkg-config pythonEnv autoPatchelfHook ];

  outputs = [ "out" ];

  # ncurses is a hidden dependency of waf when checking python
  buildInputs = lib.optionals pythonSupport [ castxml ncurses ]
    ++ lib.optionals enableDoxygen [ doxygen graphviz imagemagick ]
    ++ lib.optionals withManual [ dia tetex ghostscript imagemagick texlive.combined.scheme-medium ]
    ++ [
    libxml2
    pythonEnv
    sqlite.dev
    dpdk
    openssl.dev
    gsl
    boost
    root
    glib.out
    glib.dev
    libpcap
    libnl
    libelf
    jansson
    pcre2.dev
  ];

  propagatedBuildInputs = [ pythonEnv ];

  doCheck = true;

  buildTargets = "build"
    + lib.optionalString enableDoxygen " doxygen"
    + lib.optionalString withManual "sphinx";

  # to prevent fatal error: 'backward_warning.h' file not found
  CXXFLAGS = "-D_GLIBCXX_PERMIT_BACKWARD_HASH";

  # Make generated python bindings discoverable in customized python environment
  passthru = { pythonModule = python; };

  cmakeFlags = [
    "-DPython3_LIBRARY_DIRS=${pythonEnv}/lib"
    "-DPython3_INCLUDE_DIRS=${pythonEnv}/include"
    "-DPython3_EXECUTABLE=${pythonEnv}/bin/python"
    "-DNS3_PYTHON_BINDINGS=ON"
    "-DNS3_BINDINGS_INSTALL_DIR=lib/${pythonEnv.libPrefix}/site-packages"
  ];

  # strictoverflow prevents clang from discovering pyembed when bindings
  hardeningDisable = [ "fortify" "strictoverflow" ];

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
