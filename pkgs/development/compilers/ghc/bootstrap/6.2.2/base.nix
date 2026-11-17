# libraries/base compiled by stage 1, one module at a time in dependency order,
# retrying with -fno-strictness when the MicroHs stack or heap runs out.  The
# five modules the tarball lacks are generated first: GHC/PrimopWrappers.hs by
# genprimopcode and four .hsc files by an hsc2hs compiled with MicroHs.
{
  stdenv,
  runCommandCC,
  python3Minimal,
  ghc-bootstrap-src,
  mhs,
  mhsRuntime,
  cpphs,
  tree,
  rts,
  stage1,
}:

let
  files = "${ghc-bootstrap-src}/ghc622";
  inc = "${tree}/ghc/includes";

  # ghc/utils/unlit, which the driver runs on .lhs sources
  unlit = runCommandCC "ghc-6.2.2-unlit" { hardeningDisable = [ "all" ]; } ''
    gcc -std=gnu89 -Wno-implicit-int -Wno-implicit-function-declaration \
      -include string.h ${tree}/ghc/utils/unlit/unlit.c -o "$out"
  '';

  # GHC 6.2.2's hsc2hs compiled by MicroHs.  Main.hs includes
  # ../../includes/config.h, hence the tarball layout.  The C goes through a
  # file of a fixed name, as for genprimopcode in tree.nix.
  hsc2hs =
    runCommandCC "ghc-6.2.2-hsc2hs"
      {
        nativeBuildInputs = [
          mhs
          cpphs
        ];
        hardeningDisable = [ "all" ];
      }
      ''
        mkdir -p ghc/utils
        sh ${files}/tools/hsc2hs-src.sh ${tree} ${files}/hsc2hs/Main.hs.patch ghc/utils/hsc2hs
        ln -s ${inc} ghc/includes
        cd ghc/utils/hsc2hs
        mhs -XCPP -D__GLASGOW_HASKELL__=622 -i. -i${files}/hsc2hs/shims \
          -i${files}/shims-h98 Main -ohsc2hs.c
        cc -w -O1 -I${mhsRuntime} -I${mhsRuntime}/unix \
          ${mhsRuntime}/main.c ${mhsRuntime}/eval.c hsc2hs.c -lm -o hsc2hs
        install -D hsc2hs "$out/bin/hsc2hs"
        install -Dm644 template-hsc.h "$out/share/template-hsc.h"
      '';
in
stdenv.mkDerivation {
  pname = "ghc-6.2.2-base";
  version = "6.2.2";

  dontUnpack = true;

  nativeBuildInputs = [ python3Minimal ];

  hardeningDisable = [ "all" ];

  buildPhase = ''
    runHook preBuild

    ulimit -s unlimited

    top="$PWD/topdir"
    mkdir -p libraries "$top"
    cp -r ${tree}/libraries/base libraries/base
    chmod -R u+w libraries
    cp ${files}/base/topdir/package.conf "$top/package.conf"
    cp ${files}/base/topdir/ghc-usage.txt "$top/ghc-usage.txt"
    cp ${unlit} "$top/unlit"
    ln -s ${inc} "$top/includes"
    ln -s ${rts}/lib "$top/rts"
    ln -s ../libraries "$top/libraries"
    cd libraries/base

    ${tree.genprimopcode}/bin/genprimopcode --make-haskell-wrappers \
      < ${tree}/ghc/compiler/prelude/primops.txt > GHC/PrimopWrappers.hs
    # HsBase.h has K&R definitions
    for h in System/CPUTime System/Time System/Posix/Signals Text/Regex/Posix; do
      ${hsc2hs}/bin/hsc2hs --template=${hsc2hs}/share/template-hsc.h --cc=gcc --ld=gcc \
        --cflag=-std=gnu89 --cflag=-D__GLASGOW_HASKELL__=622 -I${inc} \
        -Iinclude -I${inc} -I. "$h.hsc"
    done

    compile() {
      timeout 1800 ${stage1}/bin/ghc +RTS -K5M -RTS "-B$top" -v1 -C \
        -fglasgow-exts -cpp -Iinclude '-#include' HsBase.h -funbox-strict-fields \
        -package-name base -O "$@" "$src" > "$log" 2>&1
    }
    mkdir -p ../../logs ../../obj
    sh ${files}/tools/base-rebuild-order.sh . ${inc} ${files}/base/after-hsc2hs.txt > "$NIX_BUILD_TOP/base-order.txt"
    test $(wc -l < "$NIX_BUILD_TOP/base-order.txt") = 147
    for m in $(cat "$NIX_BUILD_TOP/base-order.txt"); do
      p=$(echo "$m" | tr . /); log="../../logs/$m.log"
      if [ -f "$p.lhs" ]; then src="$p.lhs"; else src="$p.hs"; fi
      export TMPDIR="$NIX_BUILD_TOP/tmp/$m"; mkdir -p "$TMPDIR"
      rc=0; compile || rc=$?; note=
      if grep -qE 'ERR: stack overflow|ERR: heap exhausted|stack overflow: use \+RTS' "$log"; then
        rc=0; compile -fno-strictness || rc=$?; note=" [-fno-strictness]"
      fi
      if [ "$rc" != 0 ] || [ ! -f "$p.hc" ] || [ ! -f "$p.hi" ]; then cat "$log"; echo "FAILED: $m"; exit 1; fi
      python3 ${files}/tools/hidict.py "$p.hi" 0 "$m" >> "$log"
      echo "base $m: OK$note"

      # -fwrapv is mandatory
      gcc -c -x c -std=gnu89 -O -fwrapv -w -fno-pie -DNO_REGS -DUSE_MINIINTERPRETER \
        -D__GLASGOW_HASKELL__=622 -I${inc} -Iinclude -I. -include ${inc}/Stg.h \
        "$p.hc" -o "../../obj/$(echo "$m" | tr . _).o"
    done
    test $(ls ../../obj/*.o | wc -l) = 147

    # cbits/*.c without ilxstubs and consUtils, and the Control.Concurrent stub
    cflags="-std=gnu89 -O -w -fno-pie -DNO_REGS -DUSE_MINIINTERPRETER -DCOMPILING_STDLIB
            -D__GLASGOW_HASKELL__=622 -I${inc} -I${tree}/ghc/rts"
    mkdir ../../cbits
    for c in cbits/*.c; do
      b=$(basename "$c" .c)
      case "$b" in ilxstubs|consUtils) continue ;; esac
      gcc -c $cflags -Iinclude "$c" -o "../../cbits/$b.o"
    done
    gcc -c $cflags -Iinclude -I. Control/Concurrent_stub.c -o ../../Control_Concurrent_stub.o

    ar rcs ../../libHSbase.a ../../obj/*.o ../../Control_Concurrent_stub.o
    ar rcs ../../libHSbase_cbits.a ../../cbits/*.o
    cd ../..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libraries" "$out/lib"
    cp -r libraries/base "$out/libraries/base"
    cp libHSbase.a libHSbase_cbits.a "$out/lib/"

    runHook postInstall
  '';

  dontFixup = true;

  # Stage 2's topdir uses the same unlit
  passthru = { inherit unlit; };
}
