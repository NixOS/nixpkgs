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

    outputHashAlgo = null;
    outputHashMode = "recursive";
    outputHash = hash;
  }
  ''
    export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)

    runHook unpackPhase

    cd $sourceRoot
    zig build --fetch''${fetchAll:+=all}

    mv $ZIG_GLOBAL_CACHE_DIR/p $out
  ''
