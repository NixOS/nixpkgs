{ stdenv, fetchFromGitHub, which, m4, python, bison, flex, llvmPackages, glibc32 }:

# TODO: patch LLVM so Knights Landing works better (patch included in ispc github)

stdenv.mkDerivation rec {
  version = "20151128";
  rev = "d3020580ff18836de2d4cae18901980b551d9d01";

  name = "ispc-${version}";

  src = fetchFromGitHub {
    owner = "ispc";
    repo = "ispc";
    inherit rev;
    sha256 = "15qi22qvmlx3jrhrf3rwl0y77v66prpan6qb66a55dw3pw2d4jvn";
  };

  enableParallelBuilding = false;

  doCheck = true;

  buildInputs = with llvmPackages; [
    which
    m4
    python
    bison
    flex
    llvm
    clang
    glibc32
  ];

  # https://github.com/ispc/ispc/pull/1190
  patches = [ ./gcc5.patch ];

  postPatch = "sed -i -e 's/\\/bin\\///g' -e 's/-lcurses/-lncurses/g' Makefile";

  installPhase = ''
    mkdir -p $out/bin
    cp ispc $out/bin
  '';

  checkPhase = ''
    export ISPC_HOME=$PWD
    python run_tests.py
  '';

  makeFlags = [
    "CLANG_INCLUDE=${llvmPackages.clang-unwrapped}/include"
    ];

  meta = with stdenv.lib; {
    homepage = https://ispc.github.io/ ;
    description = "Intel 'Single Program, Multiple Data' Compiler, a vectorised language";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.aristid ];
  };
}
