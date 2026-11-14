{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_9,
  jdk,
  bison,
  flex,
  python3,
  cctools,
}:

let
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0aeaaaeee4bb913e21853a0ee0b935b2c114ae3f";
    hash = "sha256-OZjzzwO2+SmlhJvkTaW26gNvmZx0amCLF6e6MGJkRlI=";
  };
  GIT_DATE = "2026-10-29";
  GIT_VERSION = "v0.0-4298-g085eef05";
in
buildBazelPackage {
  pname = "verible";

  # Derive nix package version from GIT_VERSION: "v1.2-345-abcde" -> "1.2.345"
  version = builtins.concatStringsSep "." (
    lib.take 3 (lib.drop 1 (builtins.splitVersion GIT_VERSION))
  );

  env = {
    # These environment variables are read in bazel/build-version.sh to create
    # a build string shown in the tools --version output.
    # If env variables not set, it would attempt to extract it from .git/.
    inherit GIT_DATE GIT_VERSION;
    ${if stdenv.hostPlatform.isDarwin then "NIX_CFLAGS_COMPILE" else null} =
      "-mmacos-version-min=10.15";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    LIBTOOL = "${cctools}/bin/libtool";
  };

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    tag = GIT_VERSION;
    hash = "sha256-GJQAMsFFmdEKJG29mhXj0/yCzAFhWAIik0fe4CfQ7N0=";
  };

  bazel = bazel_9;
  strictActionEnv = false; # Because we call external flex, bison
  bazelFlags = [
    "--//bazel:use_local_flex_bison"
    "--registry"
    "file://${registry}"
  ];

  fetchAttrs = {
    # on Darwin, absl pulls in some system header, breaking the layering_check.
    preInstall = ''
      find $bazelOut/external/abseil-cpp* -type f -name BUILD.bazel -exec sed -i -e 's/"layering_check",//g' {} \;
    '';
    hash = "sha256-Zz/WoHofZA4zVJB6BAxljtJqg6FlvbO7NjQIvP4431Q=";
  };

  nativeBuildInputs = [
    jdk # bazel uses that.
    bison # We use local flex and bison as WORKSPACE sources fail
    flex # .. to compile with newer glibc
    python3
  ];

  postPatch = ''
    patchShebangs \
      .github/bin/simple-install.sh \
      bazel/build-version.sh \
      bazel/sh_test_with_runfiles_lib.sh \
      verible/common/lsp/dummy-ls_test.sh \
      verible/common/tools/patch_tool_test.sh \
      verible/common/tools/verible-transform-interactive.sh \
      verible/common/tools/verible-transform-interactive-test.sh \
      kythe-browse.sh \
      verible/verilog/tools
  '';

  preBuild = ''
    patchShebangs $bazelOut/external/rules_cc*/cc/private/toolchain/generate_system_module_map.sh
  '';

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
