# Stage 1: GHC 6.2.2's compiler proper compiled by MicroHs, with the
# ghc-on-mhs shims first on the search path.  MicroHs writes a combinator file,
# comb2c.py turns it into the C array `mhs -o ghc.c` would write, and gcc links
# that with the MicroHs runtime.
{
  stdenv,
  python3Minimal,
  ghc-bootstrap-src,
  mhs,
  mhsRuntime,
  cpphs,
  tree,
}:

let
  files = "${ghc-bootstrap-src}/ghc622";
in
stdenv.mkDerivation {
  pname = "ghc-6.2.2-stage1";
  version = "6.2.2";

  dontUnpack = true;

  nativeBuildInputs = [
    python3Minimal
    mhs
    cpphs
  ];

  hardeningDisable = [ "all" ];

  buildPhase = ''
    runHook preBuild

    TREE=${tree}/ghc/compiler
    # The defines GHC's driver passes to cpp.  Claiming GHC 4.08 makes
    # HsVersions.h pick the pre-hierarchical module names the shims provide.
    hscpp="-D__HASKELL__=98 -D__HASKELL1__=5 -D__GLASGOW_HASKELL__=408 -D__HASKELL98__ -D__CONCURRENT_HASKELL__"
    inc="-i${files}/hsboot -i${files}/shims -i${ghc-bootstrap-src}/common/shims
         -i${files}/shims-ghc -i${files}/shims-h98 -i${tree.config}"
    for d in "$TREE"/*/; do inc="$inc -i''${d%/}"; done
    inc="$inc -i$TREE -I$TREE -I${tree}/ghc/includes"

    ulimit -s unlimited 2>/dev/null || ulimit -s 4000000
    mhs +RTS -K32M -RTS -XCPP $hscpp -DOMIT_NATIVE_CODEGEN $inc Main -oghc.comb
    python3 ${files}/stage1/comb2c.py ghc.comb ghc-data.c

    # GHC's Haskell is written against wrap-around Int
    mkdir rtconf
    sed 's/^#define WANT_OVERFLOW 1/#define WANT_OVERFLOW 0/' \
      ${mhsRuntime}/unix/config.h > rtconf/config.h
    grep -q '^#define WANT_OVERFLOW 0' rtconf/config.h
    gcc -w -O3 -fno-pie -no-pie -Irtconf -I${mhsRuntime} -I${mhsRuntime}/unix \
      -I${files}/stage1 -D__MHS__ -include ${files}/stage1/stubs.h \
      ${mhsRuntime}/main.c ${mhsRuntime}/eval.c ${files}/stage1/stubs.c \
      ghc-data.c ${files}/stage1/ffi.c -lm -o ghc

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D ghc "$out/bin/ghc"
    install -Dm644 ghc.comb "$out/share/ghc.comb"

    runHook postInstall
  '';

  dontStrip = true;
}
