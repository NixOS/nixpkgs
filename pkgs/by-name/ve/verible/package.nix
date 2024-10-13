{ lib
, stdenv
, buildBazelPackage
, fetchFromGitHub
, bazel_6
, jdk
, bison
, flex
, python3
}:

let
  system = stdenv.hostPlatform.system;
in
buildBazelPackage rec {
  pname = "verible";

  # These environment variables are read in bazel/build-version.py to create
  # a build string shown in the tools --version output.
  # If env variables not set, it would attempt to extract it from .git/.
  GIT_DATE = "2024-09-17";
  GIT_VERSION = "v0.0-3791-g88bf4fb8";

  # Derive nix package version from GIT_VERSION: "v1.2-345-abcde" -> "1.2.345"
  version = builtins.concatStringsSep "." (lib.take 3 (lib.drop 1 (builtins.splitVersion GIT_VERSION)));

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo  = "verible";
    rev   = "${GIT_VERSION}";
    hash  = "sha256-Na91NpHhPRZ1k82pLQBvEcL8EWi/1imNN3dPNSl65DQ=";
  };

  bazel = bazel_6;
  bazelFlags = [
    "--//bazel:use_local_flex_bison"
  ];

  fetchAttrs = {
    hash = "sha256-bKASgc5KftCWtMvJkGA4nweBAtgdnyC9uXIJxPjKYS0=";
  };

  nativeBuildInputs = [
    jdk        # bazel uses that.
    bison      # We use local flex and bison as WORKSPACE sources fail
    flex       # .. to compile with newer glibc
    python3
  ];

  postPatch = ''
    patchShebangs\
      bazel/build-version.py \
      bazel/sh_test_with_runfiles_lib.sh \
      common/lsp/dummy-ls_test.sh \
      common/tools/patch_tool_test.sh \
      common/tools/verible-transform-interactive.sh \
      common/tools/verible-transform-interactive-test.sh \
      kythe-browse.sh \
      verilog/tools
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

      install bazel-bin/common/tools/verible-patch-tool "$out/bin"

      V_TOOLS_DIR=bazel-bin/verilog/tools
      install $V_TOOLS_DIR/diff/verible-verilog-diff "$out/bin"
      install $V_TOOLS_DIR/formatter/verible-verilog-format "$out/bin"
      install $V_TOOLS_DIR/kythe/verible-verilog-kythe-extractor "$out/bin"
      install $V_TOOLS_DIR/lint/verible-verilog-lint "$out/bin"
      install $V_TOOLS_DIR/ls/verible-verilog-ls "$out/bin"
      install $V_TOOLS_DIR/obfuscator/verible-verilog-obfuscate "$out/bin"
      install $V_TOOLS_DIR/preprocessor/verible-verilog-preprocessor "$out/bin"
      install $V_TOOLS_DIR/project/verible-verilog-project "$out/bin"
      install $V_TOOLS_DIR/syntax/verible-verilog-syntax "$out/bin"
    '';
  };

  meta = with lib; {
    description = "Suite of SystemVerilog developer tools. Including a style-linter, indexer, formatter, and language server";
    homepage = "https://github.com/chipsalliance/verible";
    license = licenses.asl20;
    maintainers = with maintainers; [ hzeller newam ];
    # Platforms linux only currently; some LIBTOOL issue on Darwin w/ bazel
    platforms = platforms.linux;
  };
}
