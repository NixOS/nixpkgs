{ stdenv
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
, lib
}:

let
  pythonEnv = python.withPackages(ps:
    stdenv.lib.optional withManual ps.sphinx
    ++ stdenv.lib.optionals pythonSupport (with ps;[ pybindgen pygccxml ])
  );
in
stdenv.mkDerivation rec {
  pname = "ns-3";
  version = "32";

  src = fetchFromGitLab {
    owner = "nsnam";
    repo   = "ns-3-dev";
    rev    = "ns-3.${version}";
    sha256 = "158yjhsrmslj1q4zcq5p16hv9i82qnxx714l7idicncn0wzrfx7k";
  };

  nativeBuildInputs = [ wafHook ];

  outputs = [ "out" ] ++ lib.optional pythonSupport "py";

  # ncurses is a hidden dependency of waf when checking python
  buildInputs = lib.optionals pythonSupport [ castxml ncurses ]
    ++ lib.optional enableDoxygen [ doxygen graphviz imagemagick ]
    ++ lib.optional withManual [ dia tetex ghostscript texlive.combined.scheme-medium ];

  propagatedBuildInputs = [ pythonEnv ];

  postPatch = ''
    patchShebangs doc/ns3_html_theme/get_version.sh
    # FIX/Remove when https://github.com/NixOS/nixpkgs/pull/69310 gets merged
    sed -i 's/program.ns3_module_dependencies.copy()/program.ns3_module_dependencies[:]/g' wscript
  '';

  wafConfigureFlags = with stdenv.lib; [
      "--enable-modules=${concatStringsSep "," modules}"
      "--with-python=${pythonEnv.interpreter}"
  ]
  ++ optional (build_profile != null) "--build-profile=${build_profile}"
  ++ optional withExamples " --enable-examples "
  ++ optional doCheck " --enable-tests "
  ;

  doCheck = true;

  buildTargets = "build"
    + lib.optionalString enableDoxygen " doxygen"
    + lib.optionalString withManual "sphinx";

  # to prevent fatal error: 'backward_warning.h' file not found
  CXXFLAGS = "-D_GLIBCXX_PERMIT_BACKWARD_HASH";

  postBuild = with stdenv.lib; let flags = concatStringsSep ";" (
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

  meta = with stdenv.lib; {
    homepage = "http://www.nsnam.org";
    license = licenses.gpl3;
    description = "A discrete time event network simulator";
    platforms = with platforms; unix;
    maintainers = with maintainers; [ teto ];
  };
}
