{stdenv, fetchFromGitHub, fetchpatch, which, m4, python, bison, flex, llvmPackages,
testedTargets ? ["sse2" "host"] # the default test target is sse4, but that is not supported by all Hydra agents
}:

stdenv.mkDerivation rec {
  version = "1.9.2";
  rev = "v${version}";

  inherit testedTargets;

  name = "ispc-${version}";

  src = fetchFromGitHub {
    owner = "ispc";
    repo = "ispc";
    inherit rev;
    sha256 = "0zaw7mwvly1csbdcbz9j8ry89n0r1fag1m1f579l4mgg1x6ksqry";
  };

  # there are missing dependencies in the Makefile, causing sporadic build failures
  enableParallelBuilding = false;

  doCheck = true;

  buildInputs = with llvmPackages; [
    which
    m4
    python
    bison
    flex
    llvm
    llvmPackages.clang-unwrapped # we need to link against libclang, so we need the unwrapped
  ];

  patches = [
    (fetchpatch {
      url = https://github.com/ispc/ispc/commit/d504641f5af9d5992e7c8f0ed42c1063a39ede5b.patch;
      sha256 = "192q3gyvam79469bmlwf0jpfi2y4f8hl2vgcvjngsqhvscwira0s";
    })
  ];

  postPatch = "sed -i -e 's/\\/bin\\///g' -e 's/-lcurses/-lncurses/g' Makefile";

  # TODO: this correctly catches errors early, but also some things that are just weird and don't seem to be real
  # errors
  #configurePhase = ''
  #  makeFlagsArray=( SHELL="${bash}/bin/bash -o pipefail" )
  #'';

  installPhase = ''
    mkdir -p $out/bin
    cp ispc $out/bin
  '';

  checkPhase = ''
    export ISPC_HOME=$PWD
    for target in $testedTargets
    do
      echo "Testing target $target"
      echo "================================"
      echo
      PATH=${llvmPackages.clang}/bin:$PATH python run_tests.py -t $target --non-interactive --verbose --file=test_output.log
      fgrep -q "No new fails"  test_output.log || exit 1
    done
  '';

  makeFlags = [
    "CXX=${stdenv.cc}/bin/clang++"
    "CLANG=${stdenv.cc}/bin/clang"
    "CLANG_INCLUDE=${llvmPackages.clang-unwrapped}/include"
    ];

  meta = with stdenv.lib; {
    homepage = https://ispc.github.io/ ;
    description = "Intel 'Single Program, Multiple Data' Compiler, a vectorised language";
    license = licenses.bsd3;
    platforms = ["x86_64-linux"]; # TODO: buildable on more platforms?
    maintainers = [ maintainers.aristid ];
  };
}
