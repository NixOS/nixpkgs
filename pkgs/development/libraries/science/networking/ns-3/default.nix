{ stdenv
, fetchFromGitLab
, python
, cmake

, sqlite
, cmake-format
, harfbuzz
, gtk3
, glib
, libxml2
, sphinx
, cppyy ? null
, gsl ? null

  # for binding generation
, castxml ? null

  # can take a long time, generates > 30000 images/graphs
, enableDoxygen ? false

  # e.g. "optimized" or "debug". If not set, use default one
, build_profile ? null

  # --enable-examples
, withExamples ? true

  # very long
, withManual ? true
, doxygen ? null
, graphviz ? null
, imagemagick ? null
  # for manual, tetex is used to get the eps2pdf binary
  # texlive to get latexmk. building manual still fails though
, dia ? null
, tetex ? null
, ghostscript ? null
, texlive ? null

  # generates python bindings
, pythonSupport ? false
, ncurses ? null

  # All modules can be enabled by choosing 'all_modules'.
  # we include here the DCE mandatory ones
, modules ? [ "core" "network" "internet" "point-to-point" "point-to-point-layout" "fd-net-device" "netanim" ]
, lib
}:

let
  pythonEnv = python.withPackages (ps:
    lib.optional withManual ps.sphinx
    ++ lib.optionals pythonSupport (with ps;[ pybindgen pygccxml cppyy ])
  );
in
stdenv.mkDerivation rec {
  pname = "ns-3";
  version = "37";

  src = fetchFromGitLab {
    owner = "nsnam";
    repo = "ns-3-dev";
    rev = "ns-3.${version}";
    sha256 = "sha256-Oj3u2P98dl2Lvyg51F/6XBdLr+8PcmT00TCVgGb30Xc=";
  };

  nativeBuildInputs = [ python cmake ];

  buildInputs = [ gtk3 sqlite cmake-format harfbuzz libxml2 sphinx gsl ]
    ++ lib.optionals pythonSupport [ castxml ncurses ]
    ++ lib.optionals enableDoxygen [ doxygen graphviz imagemagick ]
    ++ lib.optionals withManual [ dia tetex ghostscript texlive.combined.scheme-medium ];

  outputs = [ "out" ] ++ lib.optional pythonSupport "py";

  cmakeFlags = [
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  configurePhase = ''
    ${pythonEnv.interpreter} ns3 configure \
    ${lib.optionalString withExamples " --enable-examples "} \
    --out=$out \
    --enable-modules=${lib.concatStringsSep "," modules} \
    ${lib.optionalString (!isNull build_profile) " --build-profile=${build_profile} "} \
    ${lib.optionalString pythonSupport " --enable-python-bindings "} \
    --enable-tests \
    --enable-gtk -- -DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include
  '';

  buildPhase = ''
    ${pythonEnv.interpreter} ns3 build
    ${lib.optionalString enableDoxygen "${pythonEnv.interpreter} ns3 docs doxygen"}
  '';

  # we need to specify the proper interpreter else ns3 can check against a
  # different version
  checkPhase = ''
    ${pythonEnv.interpreter} ./test.py
  '';

  # TODO : find out why the fixupPhase fails

  # strictoverflow prevents clang from discovering pyembed when bindings
  hardeningDisable = [ "fortify" "strictoverflow" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "http://www.nsnam.org";
    license = licenses.gpl3;
    description = "A discrete time event network simulator";
    platforms = with platforms; unix;
    maintainers = with maintainers; [ teto rgrunbla ];
  };
}
