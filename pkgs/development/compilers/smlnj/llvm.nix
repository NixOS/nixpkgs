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
  pname = "smlnj-llvm";
  inherit src version;
  sourceRoot = "${src.name}/runtime/llvm21";
  strictDeps = true;
  __structuredAttrs = true;

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

  meta = {
    description = "Custom LLVM for Standard ML of New Jersey";
    homepage = "https://smlnj.org";
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      skyesoss
    ];
  };
}
