{stdenv, fetchFromGitHub, bash, which, m4, python, bison, flex, llvmPackages, clangWrapSelf,
testedTargets ? ["sse4" "host"]
}:

# TODO: patch LLVM so Skylake-EX works better (patch included in ispc github) - needed for LLVM 3.9?

stdenv.mkDerivation rec {
  version = "1.9.1";
  rev = "v${version}";

  inherit testedTargets;

  name = "ispc-${version}";

  src = fetchFromGitHub {
    owner = "ispc";
    repo = "ispc";
    inherit rev;
    sha256 = "1wwsyvn44hd5iyi5779l5378x096307slpyl29wrsmfp66796693";
  };

  enableParallelBuilding = true;

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
    "CXX=${llvmPackages.clang}/bin/clang++"
    "CLANG=${llvmPackages.clang}/bin/clang"
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
