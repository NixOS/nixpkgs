{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_7,
  jdk,
  bison,
  flex,
  python3,
  cctools,
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "3f863a3f35f31b61982d813835d8637b3d93d87a";
    hash = "sha256-BsxP3GrS98ubIAkFx/c4pB1i97ZZL2TijS+2ORnooww=";
  };
in
buildBazelPackage rec {
  pname = "verible";

  # These environment variables are read in bazel/build-version.py to create
  # a build string shown in the tools --version output.
  # If env variables not set, it would attempt to extract it from .git/.
  GIT_DATE = "2025-08-29";
  GIT_VERSION = "v0.0-4023-gc1271a00";

  # Derive nix package version from GIT_VERSION: "v1.2-345-abcde" -> "1.2.345"
  version = builtins.concatStringsSep "." (
    lib.take 3 (lib.drop 1 (builtins.splitVersion GIT_VERSION))
  );

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    tag = GIT_VERSION;
    hash = "sha256-N+yjRcVxFI56kP3zq+qFHNXZLTtVnQaVnseZS13YN0s=";
  };

  bazel = bazel_7;
  bazelFlags = [
    "--//bazel:use_local_flex_bison"
    "--registry"
    "file://${registry}"
  ];

  fetchAttrs = {
    hash =
      {
        aarch64-linux = "sha256-SUURIZF3mlFRFKpxdHrgYAbJQ4rkkzCeqcC/1vxmreo=";
        x86_64-linux = "sha256-p7h2L1aLzmMeWWxXC//Qau8/F4HbnUFY6aV8u7zfjRk=";
        aarch64-darwin = "sha256-Zn22un/KaHdTEA/ucaentR7t/krmnZQk3A+jfbPVYnA=";
      }
      .${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [
    jdk # bazel uses that.
    bison # We use local flex and bison as WORKSPACE sources fail
    flex # .. to compile with newer glibc
    python3
  ];
  LIBTOOL = lib.optionalString stdenv.hostPlatform.isDarwin "${cctools}/bin/libtool";

  postPatch = ''
    patchShebangs \
      .github/bin/simple-install.sh \
      bazel/build-version.py \
      bazel/sh_test_with_runfiles_lib.sh \
      verible/common/lsp/dummy-ls_test.sh \
      verible/common/tools/patch_tool_test.sh \
      verible/common/tools/verible-transform-interactive.sh \
      verible/common/tools/verible-transform-interactive-test.sh \
      kythe-browse.sh \
      verible/verilog/tools
  '';

  removeRulesCC = false;
  bazelTargets = [ ":install-binaries" ];
  bazelBuildFlags = [ "-c opt" ];

  doCheck = true;
  bazelTestTargets = [ "//..." ];
  bazelTestFlags = [ "-c opt" ];

  buildAttrs = {
    installPhase = ''
      mkdir -p "$out/bin"
      .github/bin/simple-install.sh "$out/bin"
    '';
  };

  meta = {
    description = "Suite of SystemVerilog developer tools. Including a style-linter, indexer, formatter, and language server";
    homepage = "https://github.com/chipsalliance/verible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hzeller
      newam
    ];
  };
}
