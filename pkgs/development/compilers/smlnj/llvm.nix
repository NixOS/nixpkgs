{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
  python3,
  ninja,
  src,
  version,
}:
let
  targets =
    lib.optional stdenv.targetPlatform.isx86_64 "X86"
    ++ lib.optional stdenv.targetPlatform.isAarch64 "AArch64";
in
stdenv.mkDerivation {
  pname = "smlnj-llvm-21.1";
  inherit src version;
  sourceRoot = "${src.name}/runtime/llvm21";
  nativeBuildInputs = [
    cmake
    git
    python3
    ninja
  ];
  cmakeFlags = [
    "--preset=smlnj-llvm-release"
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" (lib.concatStringsSep ";" targets))
    (lib.cmakeBool "LLVM_ENABLE_DUMP" true)
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Custom LLVM for Standard ML of New Jersey";
    homepage = "http://smlnj.org";
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      skyesoss
    ];
  };
}
