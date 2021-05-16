{ lib, stdenv, fetchFromGitHub, fetchpatch
, cmake, which, m4, python3, bison, flex, llvmPackages

  # the default test target is sse4, but that is not supported by all Hydra agents
, testedTargets ? [ "sse2" ]
}:

stdenv.mkDerivation rec {
  pname   = "ispc";
  version = "unstable-2021-04-02";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    # ISPC release 1.15.0 doesn't build against LLVM 11.1, only against 11.0. So we
    # use latest ISPC main branch for now, until they support an LLVM version we have.
    # https://github.com/ispc/ispc/issues/2027#issuecomment-784470530
    rev    = "3e8313568265d2adfbf95bd6b6e1a4c70ef59bed";
    sha256 = "sha256-gvr+VpoacmwQlP5gT4MnfmKdACZWJduVMIpR0YRzseg=";
  };

  patches = [
    # Fix cmake error: `Failed to find clang++`
    # https://github.com/ispc/ispc/pull/2055
    (fetchpatch {
      url = "https://github.com/erictapen/ispc/commit/338119b2f4e11fcf0b0852de296c320928e572a2.patch";
      sha256 = "sha256-+RqDq1LMWomu/K4SgK0Nip47b1RwyM6W0cTSNGD4+m4=";
    })
  ];

  nativeBuildInputs = [ cmake which m4 bison flex python3 llvmPackages.llvm.dev ];
  buildInputs = with llvmPackages; [
    llvm llvmPackages.libclang
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace curses ncurses
    substituteInPlace cmake/GenerateBuiltins.cmake \
      --replace 'bit 32 64' 'bit 64'
  '';

  inherit testedTargets;

  # needs 'transcendentals' executable, which is only on linux
  doCheck = stdenv.isLinux;

  # the compiler enforces -Werror, and -fno-strict-overflow makes it mad.
  # hilariously this is something of a double negative: 'disable' the
  # 'strictoverflow' hardening protection actually means we *allow* the compiler
  # to do strict overflow optimization. somewhat misleading...
  hardeningDisable = [ "strictoverflow" ];

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
    "-DLLVM_CONFIG_EXECUTABLE=${llvmPackages.llvm.dev}/bin/llvm-config"
    "-DCLANG_EXECUTABLE=${llvmPackages.clang}/bin/clang"
    "-DCLANGPP_EXECUTABLE=${llvmPackages.clang}/bin/clang++"
    "-DISPC_INCLUDE_EXAMPLES=OFF"
    "-DISPC_INCLUDE_UTILS=OFF"
    "-DARM_ENABLED=FALSE"
  ];

  meta = with lib; {
    homepage    = "https://ispc.github.io/";
    description = "Intel 'Single Program, Multiple Data' Compiler, a vectorised language";
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ]; # TODO: buildable on more platforms?
    maintainers = with maintainers; [ aristid thoughtpolice ];
  };
}
