{
  lib,
  zig,
  runCommand,
}:
{
  pname,
  version,
  name ? "${pname}-${version}",
  src,
  fetchAll ? false,
  hash ? lib.fakeHash,
}:
runCommand "${name}-zig-deps"
  {
    inherit src fetchAll;

    nativeBuildInputs = [ zig ];

    outputHashAlgo = if hash == "" then "sha256" else null;
    outputHashMode = "recursive";
    outputHash = hash;
  }
  (
    ''
      export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    ''
    # work around: https://codeberg.org/ziglang/zig/issues/31964 and https://codeberg.org/ziglang/zig/issues/35264
    # fixes builds for zig 0.16.0
    + lib.optionalString (
      lib.versions.majorMinor zig.version == "0.16"
    ) "mkdir -p $ZIG_GLOBAL_CACHE_DIR/tmp\n"
    + ''
      runHook unpackPhase

      cd $sourceRoot
      zig build --fetch''${fetchAll:+=all}

      mv $ZIG_GLOBAL_CACHE_DIR/p $out
    ''
  )
