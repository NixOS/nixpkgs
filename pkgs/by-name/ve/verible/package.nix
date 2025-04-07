{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_6,
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
    rev = "bac7a5dc8b5535d7b36d0405f76badfba77c84c2";
    hash = "sha256-TXooqzqfvf1twldfrs0m8QR3AJkUCIyBS36TFTwN4Eg=";
  };
in
buildBazelPackage rec {
  pname = "verible";

  # These environment variables are read in bazel/build-version.py to create
  # a build string shown in the tools --version output.
  # If env variables not set, it would attempt to extract it from .git/.
  GIT_DATE = "2025-03-30";
  GIT_VERSION = "v0.0-3956-ge12a194d";

  # Derive nix package version from GIT_VERSION: "v1.2-345-abcde" -> "1.2.345"
  version = builtins.concatStringsSep "." (
    lib.take 3 (lib.drop 1 (builtins.splitVersion GIT_VERSION))
  );

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    rev = "${GIT_VERSION}";
    hash = "sha256-/RZqBNmyBZI6CO2ffS6p8T4wse1MKytNMphXFdkTOWQ=";
  };

  bazel = bazel_6;
  bazelFlags = [
    "--//bazel:use_local_flex_bison"
    "--registry"
    "file://${registry}"
  ];

  fetchAttrs = {
    hash =
      {
        aarch64-linux = "sha256-ErhBpmXhtiZbBWy506rLp4TQh5oXJQ44lw25jlVkjUM=";
        x86_64-linux = "sha256-d8CYiqpL7rM3VvEqHSBvtgF2WLyH23jSvK7w4ChTtgU=";
        aarch64-darwin = "sha256-lHMbziDzQpmXvsW25SgjQUkPRIRYv6TJIPTAEvhSfuA=";
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

  meta = with lib; {
    description = "Suite of SystemVerilog developer tools. Including a style-linter, indexer, formatter, and language server";
    homepage = "https://github.com/chipsalliance/verible";
    license = licenses.asl20;
    maintainers = with maintainers; [
      hzeller
      newam
    ];
  };
}
