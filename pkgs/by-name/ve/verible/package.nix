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
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "6ca6e91cb9fa2d224f61b8a4a2a7fd6b1211e388";
    hash = "sha256-LRD8sGbISp2LXjpg4cpbUHG2a1JbKLA7z3vSvqqXMGo=";
  };
in
buildBazelPackage rec {
  pname = "verible";

  # These environment variables are read in bazel/build-version.py to create
  # a build string shown in the tools --version output.
  # If env variables not set, it would attempt to extract it from .git/.
  GIT_DATE = "2025-01-02";
  GIT_VERSION = "v0.0-3894-g0a842c85";

  # Derive nix package version from GIT_VERSION: "v1.2-345-abcde" -> "1.2.345"
  version = builtins.concatStringsSep "." (
    lib.take 3 (lib.drop 1 (builtins.splitVersion GIT_VERSION))
  );

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    rev = "${GIT_VERSION}";
    hash = "sha256-FWeEIWvrjE8ESGFUWDPtd9gLkhMDtgkw6WbXViDxQQA=";
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
        aarch64-linux = "sha256-HPpRxYhS6CIhinhHNvnPij4+cJxqf073nGpNG1ItPmo=";
        x86_64-linux = "sha256-gM4hsuHMF4V1PgykjQ0yO652luoRJvNdB2xF6P8uxRc=";
      }
      .${system} or (throw "No hash for system: ${system}");
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
    # Platforms linux only currently; some LIBTOOL issue on Darwin w/ bazel
    platforms = platforms.linux;
  };
}
