{
  lib,
  runCommand,
  zig,
  stdenv,
  makeWrapper,
  coreutils,
}:
let
  targetPrefix = lib.optionalString (
    stdenv.hostPlatform != stdenv.targetPlatform
  ) "${stdenv.targetPlatform.config}-";
in
runCommand "zig-cc-${zig.version}"
  {
    pname = "zig-cc";
    inherit (zig) version;

    nativeBuildInputs = [ makeWrapper ];

    passthru = {
      isZig = true;
      inherit targetPrefix;
    };

    inherit zig;

    meta = zig.meta // {
      mainProgram = "${targetPrefix}clang";
    };
  }
  ''
    mkdir -p $out/bin
    for tool in cc c++ ld.lld; do
      makeWrapper "$zig/bin/zig" "$out/bin/$tool" \
        --add-flags "$tool" \
        --suffix PATH : "${lib.makeBinPath [ coreutils ]}" \
        --run "export ZIG_GLOBAL_CACHE_DIR=\$(mktemp -d)"
    done

    ln -s $out/bin/c++ $out/bin/clang++
    ln -s $out/bin/cc $out/bin/clang
    ln -s $out/bin/ld.lld $out/bin/ld
  ''
