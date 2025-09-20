{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_7,
  jdk,
  python3,
  cctools,
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "ef470614dde092c96b2b757c23d9377fcc101d24";
    hash = "sha256-GvteC/xEFWA+ahA/PCjWiPxLvMBvGDQS4YsL3cOQPe8=";
  };
in
buildBazelPackage rec {
  pname = "verible";

  # These environment variables are read in bazel/build-version.py to create
  # a build string shown in the tools --version output.
  # If env variables not set, it would attempt to extract it from .git/.
  GIT_DATE = "2025-08-27";
  GIT_VERSION = "v0.0-4019-gc2540abe";

  # Derive nix package version from GIT_VERSION: "v1.2-345-abcde" -> "1.2.345"
  version = builtins.concatStringsSep "." (
    lib.take 3 (lib.drop 1 (builtins.splitVersion GIT_VERSION))
  );

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    rev = "${GIT_VERSION}";
    hash = "sha256-Sjlgr3QZ8yqwo2zV5fsaISJ/pv8P6lGiP28gSXTpssQ=";
  };

  bazel = bazel_7;
  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];

  fetchAttrs = {
    hash =
      {
        aarch64-linux = "sha256-jgh+wEqZba30MODmgmPoQn1ErNmm40d17jB/kE2jYPg=";
        x86_64-linux = "sha256-kqVHv+qDKbAIvgTisr2CIhZXrjnufwatQkqUQtsFMQY=";
        aarch64-darwin = "sha256-bkw4ErWYblzr4lQhoXSBqIBHjXzhZHeTKdT0E/YsiFQ=";
      }
      .${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [
    jdk # bazel uses that.
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
