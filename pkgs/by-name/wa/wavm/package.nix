{
  lib,
  llvmPackages_12,
  fetchFromGitHub,
  cmake,
}:

llvmPackages_12.stdenv.mkDerivation (finalAttrs: {
  pname = "wavm";
  version = "2022-05-14";

  src = fetchFromGitHub {
    owner = "WAVM";
    repo = "WAVM";
    rev = "nightly/${finalAttrs.version}";
    hash = "sha256-SHz+oOOkwvVZucJYFSyZc3MnOAy1VatspmZmOAXYAWA=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages_12.llvm
  ];

  meta = {
    description = "WebAssembly Virtual Machine";
    mainProgram = "wavm";
    homepage = "https://wavm.github.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ereslibre ];
    platforms = lib.platforms.unix;
  };
})
