{stdenv, fetchFromGitHub, cmake, which, m4, python3, bison, flex, llvmPackages,
testedTargets ? ["sse2"] # the default test target is sse4, but that is not supported by all Hydra agents
}:

stdenv.mkDerivation rec {
  version = "1.12.0";
  rev = "v${version}";

  inherit testedTargets;

  pname = "ispc";

  src = fetchFromGitHub {
    owner = "ispc";
    repo = "ispc";
    inherit rev;
    sha256 = "1g0a17c1b5s0272awcg210k4lfcx857agmcm2a2a6rsh0afhmy7w";
  };

  doCheck = stdenv.isLinux;

  # LLVM uses -Werror but also runs clang on assembly files, which
  # makes -fno-strict-overflow break the build.
  hardeningDisable = ["strictoverflow"];

  nativeBuildInputs = [ cmake ];
  buildInputs = with llvmPackages; [
    which
    m4
    python3
    bison
    flex
    llvm
    llvmPackages.clang-unwrapped # we need to link against libclang, so we need the unwrapped
  ];

  postPatch = "sed -i -e 's/curses/ncurses/g' CMakeLists.txt";

  # TODO: this correctly catches errors early, but also some things that are just weird and don't seem to be real
  # errors
  #configurePhase = ''
  #  makeFlagsArray=( SHELL="${bash}/bin/bash -o pipefail" )
  #'';

  checkPhase = ''
    export ISPC_HOME=$PWD/bin
    for target in $testedTargets
    do
      echo "Testing target $target"
      echo "================================"
      echo
      (cd ../
       PATH=${llvmPackages.clang}/bin:$PATH python run_tests.py -t $target --non-interactive --verbose --file=test_output.log
       fgrep -q "No new fails"  test_output.log || exit 1)
    done
  '';

  cmakeFlags = [
    "-DCLANG_EXECUTABLE=${llvmPackages.clang}/bin/clang"
    "-DISPC_INCLUDE_EXAMPLES=OFF"
    "-DISPC_INCLUDE_UTILS=OFF"
    ];

  meta = with stdenv.lib; {
    homepage = https://ispc.github.io/ ;
    description = "Intel 'Single Program, Multiple Data' Compiler, a vectorised language";
    license = licenses.bsd3;
    platforms = ["x86_64-linux" "x86_64-darwin"]; # TODO: buildable on more platforms?
    maintainers = [ maintainers.aristid ];
  };
}
