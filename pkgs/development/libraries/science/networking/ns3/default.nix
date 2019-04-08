{ stdenv
, fetchFromGitHub
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
, generateBindings ? false, ncurses ? null

# All modules can be enabled by choosing 'all_modules'.
# we include here the DCE mandatory ones
, modules ? [ "core" "network" "internet" "point-to-point" "fd-net-device" "netanim"]
, gcc6
, lib
}:

let
  pythonEnv = python.withPackages(ps:
    stdenv.lib.optional withManual ps.sphinx
    ++ stdenv.lib.optionals generateBindings (with ps;[ pybindgen pygccxml ])
  );
in
stdenv.mkDerivation rec {

  name = "ns-3.${version}";
  version = "28";

  # the all in one https://www.nsnam.org/release/ns-allinone-3.27.tar.bz2;
  # fetches everything (netanim, etc), this package focuses on ns3-core
  src = fetchFromGitHub {
    owner  = "nsnam";
    repo   = "ns-3-dev-git";
    rev    = name;
    sha256 = "17kzfjpgw2mvyx1c9bxccnvw67jpk09fxmcnlkqx9xisk10qnhng";
  };

  nativeBuildInputs = [ wafHook ];
  # ncurses is a hidden dependency of waf when checking python
  buildInputs = lib.optionals generateBindings [ castxml ncurses ]
    ++ stdenv.lib.optional enableDoxygen [ doxygen graphviz imagemagick ]
    ++ stdenv.lib.optional withManual [ dia tetex ghostscript texlive.combined.scheme-medium ];

  propagatedBuildInputs = [ gcc6 pythonEnv ];

  postPatch = ''
    patchShebangs doc/ns3_html_theme/get_version.sh
  '';

  configureFlags = with stdenv.lib; [
      "--enable-modules=${stdenv.lib.concatStringsSep "," modules}"
      "--with-python=${pythonEnv.interpreter}"
  ]
  ++ optional (build_profile != null) "--build-profile=${build_profile}"
  ++ optional generateBindings [  ]
  ++ optional withExamples " --enable-examples "
  ++ optional doCheck " --enable-tests "
  ;

  buildTargets = "build"
    + lib.optionalString enableDoxygen " doxygen"
    + lib.optionalString withManual "sphinx";

  doCheck = true;

  # we need to specify the proper interpreter else ns3 can check against a
  # different version even though we
  checkPhase =  ''
    ${pythonEnv.interpreter} ./test.py
  '';

  hardeningDisable = [ "fortify" ];

  meta = {
    homepage = http://www.nsnam.org;
    license = stdenv.lib.licenses.gpl3;
    description = "A discrete time event network simulator";
    platforms = with stdenv.lib.platforms; unix;
  };
}
