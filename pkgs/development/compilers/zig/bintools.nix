{
  lib,
  stdenv,
  zig,
  runCommandNoCC,
  makeWrapper,
}:
let
  targetPrefix = lib.optionalString (
    stdenv.hostPlatform != stdenv.targetPlatform
  ) "${stdenv.targetPlatform.config}-";
in
runCommandNoCC "zig-bintools-${zig.version}"
  {
    pname = "zig-bintools";
    inherit (zig) version meta;

    nativeBuildInputs = [ makeWrapper ];

    passthru = {
      isZig = true;
      inherit targetPrefix;
    };

    inherit zig;
  }
  ''
    mkdir -p $out/bin
    for tool in ar objcopy; do
      makeWrapper "$zig/bin/zig" "$out/bin/${targetPrefix}-$tool" \
        --add-flags "$tool" \
        --run "export ZIG_GLOBAL_CACHE_DIR=\$(mktemp -d)"
    done
  ''
