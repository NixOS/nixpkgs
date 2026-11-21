# GHC 6.2.2's runtime system, unregisterised x86-64, compiled with gcc alone:
# every C file of ghc/rts except the excluded ones, the hand-written .hc files
# and the generated AutoApply.hc, with the flags GHC's Makefiles would pass.
# -std=gnu89 for the 2004 C, and -fno-pie because the chain was verified
# non-PIE.
{
  stdenv,
  runCommandCC,
  ghc-bootstrap-src,
  mhs,
  cpphs,
  tree,
}:

let
  files = "${ghc-bootstrap-src}/ghc622";

  # genapply compiled by MicroHs; the tarball does not ship its output
  autoApply =
    runCommandCC "ghc-6.2.2-AutoApply.hc"
      {
        nativeBuildInputs = [
          mhs
          cpphs
        ];
        hardeningDisable = [ "all" ];
      }
      ''
        cp ${tree}/ghc/utils/genapply/GenApply.hs .
        mhs -XCPP -D__GLASGOW_HASKELL__=622 -DNO_REGS -I${tree}/ghc/utils/genapply \
          -i. -i${files}/rts/genapply-shim GenApply.hs -ogenapply
        ./genapply > "$out"
      '';
in
stdenv.mkDerivation {
  pname = "ghc-6.2.2-rts";
  version = "6.2.2";

  unpackPhase = ''
    runHook preUnpack

    mkdir ghc
    cp -r ${tree}/ghc/rts ${tree}/ghc/includes ghc/
    chmod -R u+w ghc
    cp ${autoApply} AutoApply.hc

    runHook postUnpack
  '';

  patchPhase = ''
    runHook prePatch

    for p in ${files}/rts/patches/*.patch; do
      msg=$(patch -p1 -N -i "$p" 2>&1) || { echo "$msg"; echo "FAILED: $p"; exit 1; }
      case "$msg" in *fuzz*|*offset*) echo "$msg"; echo "INEXACT: $p"; exit 1 ;; esac
    done

    runHook postPatch
  '';

  hardeningDisable = [ "all" ];

  dontUpdateAutotoolsGnuConfigScripts = true;
  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    flags="-std=gnu89 -O -w -fno-pie -DNO_REGS -DUSE_MINIINTERPRETER -DCOMPILING_RTS
           -D__GLASGOW_HASKELL__=622 -Ighc/includes -Ighc/rts -Ighc/rts/parallel"
    mkdir obj
    for src in ghc/rts/*.c ghc/rts/hooks/*.c ghc/rts/parallel/*.c; do
      base=$(basename "$src" .c)
      case "$base" in RtsDllMain|SysMan|Vis*) continue ;; esac
      gcc -c $flags "$src" -o "obj/$base.o"
    done
    for src in ghc/rts/*.hc ghc/rts/parallel/*.hc AutoApply.hc; do
      gcc -c -x c $flags -include ghc/includes/Stg.h "$src" -o "obj/$(basename "$src" .hc).o"
    done
    ls obj/*.o | wc -l | grep -qx 78
    ar rcs libHSrts.a obj/*.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 libHSrts.a "$out/lib/libHSrts.a"

    runHook postInstall
  '';

  dontStrip = true;
}
