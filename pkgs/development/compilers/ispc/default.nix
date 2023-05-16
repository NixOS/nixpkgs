{ lib, stdenv, fetchFromGitHub, fetchpatch
<<<<<<< HEAD
, cmake, which, m4, python3, bison, flex, llvmPackages, ncurses, xcode, tbb
=======
, cmake, which, m4, python3, bison, flex, llvmPackages, ncurses

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # the default test target is sse4, but that is not supported by all Hydra agents
, testedTargets ? if stdenv.isAarch64 || stdenv.isAarch32 then [ "neon-i32x4" ] else [ "sse2-i32x4" ]
}:

stdenv.mkDerivation rec {
  pname   = "ispc";
<<<<<<< HEAD
  version = "1.21.0";
=======
  version = "1.18.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256:029rlkh7vh8hxg8ygpspxb9hvw5q97m460zbxwb7xnx1jnq8msh4";
  };

  nativeBuildInputs = [ cmake which m4 bison flex python3 llvmPackages.libllvm.dev tbb ] ++ lib.lists.optionals stdenv.isDarwin [ xcode ];

=======
    sha256 = "sha256-WBAVgjQjW4x9JGx6xotPoTVOePsPjBJEyBYA7TCTBvc=";
  };

  nativeBuildInputs = [ cmake which m4 bison flex python3 llvmPackages.libllvm.dev ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = with llvmPackages; [
    libllvm libclang openmp ncurses
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace CURSES_CURSES_LIBRARY CURSES_NCURSES_LIBRARY
    substituteInPlace cmake/GenerateBuiltins.cmake \
      --replace 'bit 32 64' 'bit 64'
  '';

  inherit testedTargets;

<<<<<<< HEAD
  doCheck = true;
=======
  # needs 'transcendentals' executable, which is only on linux
  doCheck = stdenv.isLinux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    "-DFILE_CHECK_EXECUTABLE=${llvmPackages.llvm}/bin/FileCheck"
    "-DLLVM_AS_EXECUTABLE=${llvmPackages.llvm}/bin/llvm-as"
    "-DLLVM_CONFIG_EXECUTABLE=${llvmPackages.llvm.dev}/bin/llvm-config"
    "-DLLVM_DIS_EXECUTABLE=${llvmPackages.llvm}/bin/llvm-dis"
=======
    "-DLLVM_CONFIG_EXECUTABLE=${llvmPackages.llvm.dev}/bin/llvm-config"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "-DCLANG_EXECUTABLE=${llvmPackages.clang}/bin/clang"
    "-DCLANGPP_EXECUTABLE=${llvmPackages.clang}/bin/clang++"
    "-DISPC_INCLUDE_EXAMPLES=OFF"
    "-DISPC_INCLUDE_UTILS=OFF"
    ("-DARM_ENABLED=" + (if stdenv.isAarch64 || stdenv.isAarch32 then "TRUE" else "FALSE"))
    ("-DX86_ENABLED=" + (if stdenv.isx86_64 || stdenv.isx86_32 then "TRUE" else "FALSE"))
<<<<<<< HEAD
  ] ++ lib.lists.optionals stdenv.isDarwin [
    "-DISPC_MACOS_SDK_PATH=${xcode}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    homepage    = "https://ispc.github.io/";
    description = "Intel 'Single Program, Multiple Data' Compiler, a vectorised language";
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ]; # TODO: buildable on more platforms?
<<<<<<< HEAD
    maintainers = with maintainers; [ aristid thoughtpolice athas alexfmpe ];
=======
    maintainers = with maintainers; [ aristid thoughtpolice athas ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
