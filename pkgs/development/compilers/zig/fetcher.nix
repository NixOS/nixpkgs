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
  hash ? lib.fakeHash,
}@args:
runCommand "${name}-zig-deps"
  {
    inherit (args) src;

    nativeBuildInputs = [ zig ];

    outputHashAlgo = null;
    outputHashMode = "recursive";
    outputHash = hash;
  }
  ''
    export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)

    runHook unpackPhase

    cd $sourceRoot
    zig build --fetch

    mv $ZIG_GLOBAL_CACHE_DIR/p $out
  ''
