{ stdenv
, lib
, cmake
, coreutils
, python3
, git
, fetchFromGitHub
, ninja
, gitUpdater
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.psutil ]);
in
stdenv.mkDerivation rec {
  pname = "circt";
  version = "1.56.1";
  src = fetchFromGitHub {
    owner = "llvm";
    repo = "circt";
    rev = "firtool-${version}";
    sha256 = "sha256-MOwjfSUd5Dvlvek763AMZWK29dUoc2fblb5qtByTqLA=";
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
    find ./test -name '*.mlir' -exec sed -i 's|/usr/bin/env|${coreutils}/bin/env|g' {} \;
    # circt uses git to check its version, but when cloned on nix it can't access git.
    # So this hard codes the version.
    substituteInPlace cmake/modules/GenVersionFile.cmake --replace "unknown git version" "${src.rev}"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv bin/{{fir,hls}tool,circt-{as,dis,lsp-server,opt,reduce,translate}} $out/bin
    runHook postInstall
  '';

  doCheck = true;
  checkTarget = "check-circt check-circt-integration";

  passthru.updateScript = gitUpdater {
    rev-prefix = "firtool-";
  };

  meta = {
    description = "Circuit IR compilers and tools";
    homepage = "https://circt.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sharzy pineapplehunter ];
    platforms = lib.platforms.all;
  };
}

