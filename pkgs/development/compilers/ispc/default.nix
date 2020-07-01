{ stdenv, fetchFromGitHub
, cmake, which, m4, python3, bison, flex, llvmPackages

  # the default test target is sse4, but that is not supported by all Hydra agents
, testedTargets ? [ "sse2" ]
}:

stdenv.mkDerivation rec {
  pname   = "ispc";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1l74xkpwwxc38k2ngg7mpvswziiy91yxslgfad6688hh1n5jvayd";
  };

  nativeBuildInputs = [ cmake which m4 bison flex python3 ];
  buildInputs = with llvmPackages; [
    # we need to link against libclang, so we need the unwrapped
    llvm llvmPackages.clang-unwrapped
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
    "-DCLANG_EXECUTABLE=${llvmPackages.clang}/bin/clang"
    "-DISPC_INCLUDE_EXAMPLES=OFF"
    "-DISPC_INCLUDE_UTILS=OFF"
    "-DARM_ENABLED=FALSE"
  ];

  meta = with stdenv.lib; {
    homepage    = "https://ispc.github.io/";
    description = "Intel 'Single Program, Multiple Data' Compiler, a vectorised language";
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ]; # TODO: buildable on more platforms?
    maintainers = with maintainers; [ aristid thoughtpolice ];
  };
}
