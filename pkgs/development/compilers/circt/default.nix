{ stdenv
, lib
, cmake
, coreutils
, python3
, git
, fetchFromGitHub
, ninja
<<<<<<< HEAD
, gitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.psutil ]);
in
stdenv.mkDerivation rec {
  pname = "circt";
<<<<<<< HEAD
  version = "1.54.0";
=======
  version = "1.40.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "llvm";
    repo = "circt";
    rev = "firtool-${version}";
<<<<<<< HEAD
    sha256 = "sha256-jHDQl6UJTyNGZ4PUTEiZCIN/RSRbBxlaVutkwrWbK9M=";
=======
    sha256 = "sha256-L114Xh0O/Wu8IyrKohxalyXeSe/8oVcAXD4hpa6ocwU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  requiredSystemFeatures = [ "big-parallel" ];

  nativeBuildInputs = [ cmake ninja git pythonEnv ];

  cmakeDir = "../llvm/llvm";
  cmakeFlags = [
    "-DLLVM_ENABLE_BINDINGS=OFF"
    "-DLLVM_ENABLE_OCAMLDOC=OFF"
    "-DLLVM_BUILD_EXAMPLES=OFF"
    "-DLLVM_OPTIMIZED_TABLEGEN=ON"
    "-DLLVM_ENABLE_PROJECTS=mlir"
    "-DLLVM_EXTERNAL_PROJECTS=circt"
    "-DLLVM_EXTERNAL_CIRCT_SOURCE_DIR=.."
    "-DCIRCT_LLHD_SIM_ENABLED=OFF"
  ];

  # There are some tests depending on `clang-tools` to work. They are activated only when detected
  # `clang-tidy` in PATH, However, we cannot simply put `clang-tools` in checkInputs to make these
  # tests work. Because
  #
  # 1. The absolute paths of binaries used in tests are resolved in configure phase.
  # 2. When stdenv = clangStdenv, the `clang-tidy` binary appears in PATH via `clang-unwrapped`,
  #    which is always placed before `${clang-tools}/bin` in PATH. `clang-tidy` provided in
  #    `clang-unwrapped` cause tests failing because it is not wrapped to resolve header search paths.
  #    https://github.com/NixOS/nixpkgs/issues/214945 discusses this issue.
  #
  # As a temporary fix, we disabled these tests when using clang stdenv
  # cannot use lib.optionalString as it creates an empty string, disabling all tests
  LIT_FILTER_OUT = if stdenv.cc.isClang then "CIRCT :: Target/ExportSystemC/.*\.mlir" else null;

  preConfigure = ''
<<<<<<< HEAD
    find ./test -name '*.mlir' -exec sed -i 's|/usr/bin/env|${coreutils}/bin/env|g' {} \;
    # circt uses git to check its version, but when cloned on nix it can't access git.
    # So this hard codes the version.
    substituteInPlace cmake/modules/GenVersionFile.cmake --replace "unknown git version" "${src.rev}"
=======
    substituteInPlace test/circt-reduce/test/annotation-remover.mlir --replace "/usr/bin/env" "${coreutils}/bin/env"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv bin/{{fir,hls}tool,circt-{as,dis,lsp-server,opt,reduce,translate}} $out/bin
    runHook postInstall
  '';

  doCheck = true;
  checkTarget = "check-circt check-circt-integration";

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    rev-prefix = "firtool-";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "Circuit IR compilers and tools";
    homepage = "https://circt.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sharzy ];
    platforms = lib.platforms.all;
  };
}

