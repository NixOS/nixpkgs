# Stage 2: GHC 6.2.2's compiler proper compiled by stage 1 into a native
# compiler.
#
# The source is the pristine tarball, not the patched tree, plus the parsers,
# primop tables, main/Config.hs and ghc/includes the tree regenerated.
# Lexer.hs stays the shipped alex output, whose Addr# tables a native GHC reads.
#
# Stage 1 compiles the 220 modules one by one in three derivations of roughly
# 45 minutes each, so that a late failure does not redo the whole compile.
# Some modules crash it at -O and are retried with -fno-strictness, then -O0.
# The last derivation compiles the C, links the compiler and has it compile
# Hello.hs.
{
  lib,
  stdenv,
  runCommand,
  python3Minimal,
  ghc-bootstrap-src,
  gmp,
  tree,
  rts,
  stage1,
  base,
}:

let
  files = "${ghc-bootstrap-src}/ghc622";
  hidict = "${files}/tools/hidict.py";
  ghc1 = "${stage1}/bin/ghc";

  src = runCommand "ghc-6.2.2-stage2-src" { } ''
    mkdir "$out"
    tar xjf ${tree.src} -C "$out" --strip-components=1 \
      ghc-6.2.2/ghc ghc-6.2.2/mk ghc-6.2.2/libraries/base ghc-6.2.2/libraries/haskell98
    chmod -R u+w "$out"
    C="$out/ghc/compiler"
    cp -r --no-preserve=mode ${tree.parsers}/. "$C/"
    cp ${tree.primops}/primops.txt "$C/prelude/"
    cp ${tree.primops}/primop-*.hs-incl "$C/"
    sed 's/^cBooterVersion        = "4.08.2"$/cBooterVersion        = "6.2.2"/' \
      ${tree.config}/Config.hs > "$C/main/Config.hs"
    grep -q '"6.2.2"' "$C/main/Config.hs"
    rm -r "$out/ghc/includes"
    cp -r --no-preserve=mode ${tree}/ghc/includes "$out/ghc/includes"
  '';

  # The 220 modules of the compiler proper in dependency order
  order = runCommand "ghc-6.2.2-stage2-order" { nativeBuildInputs = [ python3Minimal ]; } ''
    python3 ${files}/tools/make-order.py ${src}/ghc/compiler > "$out"
    test $(wc -l < "$out") = 220
  '';

  # An installed layout for the compiler's -B flag.  The argument is the
  # directory holding haskell98's .hi files and libHShaskell98.a.
  mkTopdir = h98: ''
    mkdir -p topdir/libraries
    cp ${files}/stage2/topdir/package.conf topdir/package.conf
    cp ${files}/stage2/topdir/ghc-usage.txt topdir/ghc-usage.txt
    cp ${base.unlit} topdir/unlit
    ln -s ${src}/ghc/includes topdir/includes
    ln -s ${rts}/lib topdir/rts
    ln -s ${base}/libraries/base topdir/libraries/base
    ln -s ${base}/lib topdir/libraries/base-lib
    ln -s ${h98} topdir/libraries/haskell98
  '';

  haskell98 = stdenv.mkDerivation {
    pname = "ghc-6.2.2-haskell98";
    version = "6.2.2";

    dontUnpack = true;

    nativeBuildInputs = [ python3Minimal ];

    hardeningDisable = [ "all" ];

    buildPhase = ''
      runHook preBuild

      ulimit -s unlimited
      cp -r --no-preserve=mode ${src}/libraries/haskell98 h98
      ${mkTopdir "\"$PWD/h98\""}
      cd h98
      for m in Ix Array Bits CError CForeign CPUTime CString CTypes Char Complex \
               Directory ForeignPtr IO Int List Locale MarshalAlloc MarshalArray \
               MarshalError MarshalUtils Maybe Monad Ptr Random Ratio StablePtr \
               Storable System Time Word; do
        export TMPDIR="$NIX_BUILD_TOP/tmp/$m"; mkdir -p "$TMPDIR"
        (ulimit -v 8000000; timeout 1800 ${ghc1} +RTS -K20M -RTS "-B$NIX_BUILD_TOP/topdir" \
           -v1 -C -O -package-name haskell98 -package base "$m.hs") > "$m.log" 2>&1 \
          || { cat "$m.log"; echo "FAILED: $m"; exit 1; }
        python3 ${hidict} "$m.hi" 0 "$m" >> "$m.log"
        gcc -c -x c -std=gnu89 -O -fwrapv -w -fno-pie -DNO_REGS -DUSE_MINIINTERPRETER \
          -D__GLASGOW_HASKELL__=602 -I${src}/ghc/includes -I${src}/libraries/base/include \
          -include ${src}/ghc/includes/Stg.h "$m.hc" -o "$m.o"
        echo "haskell98 $m: OK"
      done
      ar rcs libHShaskell98.a *.o

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir "$out"
      cp *.hi *.hc libHShaskell98.a "$out/"

      runHook postInstall
    '';

    dontFixup = true;
  };

  # Compiles lines `from` to `to` of `order` to .hi and .hc, starting from the
  # output of `prev`.  The defaults are stage 2's; stages 3 to 5 pass a native
  # compiler, without the fix-ups for what the MicroHs runtime cannot read and
  # without stage 1's per-module flags.
  hcChunk =
    {
      part,
      from,
      to,
      prev ? null,
      stage ? "stage2",
      ghc ? ghc1,
      fixups ? true,
      flags ? "${files}/stage2/flags.tsv",
      modTimeout ? 3600,
    }:
    stdenv.mkDerivation {
      pname = "ghc-6.2.2-${stage}-hc${toString part}";
      version = "6.2.2";

      dontUnpack = true;

      nativeBuildInputs = [ python3Minimal ];

      hardeningDisable = [ "all" ];

      buildPhase = ''
        runHook preBuild

        ulimit -s unlimited
        ${mkTopdir haskell98}
        top="$PWD/topdir"; odir="$PWD/${stage}"
        mkdir -p ${stage} logs
        ${lib.optionalString (
          prev != null
        ) "cp -r --no-preserve=mode ${prev}/${stage}/. ${stage}/; cp ${prev}/logs/* logs/"}
        cp -r --no-preserve=mode ${src}/ghc src
        SRC="$PWD/src/compiler"
        ${lib.optionalString fixups ''FIX="$PWD/fixups"; sh ${files}/tools/make-fixups.sh "$SRC" ${files}/stage2/fixups "$FIX"''}
        idirs=
        for d in utils basicTypes types hsSyn prelude rename typecheck deSugar coreSyn \
                 specialise simplCore stranal stgSyn simplStg codeGen absCSyn main \
                 profiling parser cprAnalysis compMan ndpFlatten; do
          mkdir -p "$odir/$d"; idirs="$idirs -i$odir/$d"
          for b in "$SRC/$d"/*.hi-boot*; do [ -f "$b" ] && ln -s "$b" "$odir/$d/"; done
        done
        extra_flags() {
          case "$1" in
            utils/Binary.hs) echo "-funbox-strict-fields -O" ;;
            main/ParsePkgConf.hs|parser/Parser.hs) echo "-fno-warn-incomplete-patterns" ;;
            parser/Lexer.hs) echo "-funbox-strict-fields" ;;
            main/BinIface.hs|utils/FastMutInt.lhs) echo "-O" ;;
            compMan/CompManager.lhs|main/CmdLineOpts.lhs|main/DriverFlags.hs|main/DriverMkDepend.hs|main/DriverPipeline.hs|main/DriverState.hs|main/DriverUtil.hs|main/Finder.lhs|main/SysTools.lhs) echo "-fno-cse" ;;
            prelude/PrimOp.lhs) echo "-no-recomp" ;;
          esac
        }
        attempt() {
          rm -f "$hc" "$hi"
          ( cd "$SRC"; ulimit -v 8000000
            timeout ${toString modTimeout} ${ghc} +RTS -K50M -RTS "-B$top" -v1 -C \
              -cpp -fglasgow-exts -I. -IcodeGen -InativeGen -Iparser -DOMIT_NATIVE_CODEGEN \
              '-#include' '"hschooks.h"' -recomp $idirs $1 $extra -o "$hc" -ohi "$hi" "$srcf" ) < /dev/null > "$log" 2>&1
        }
        retryable() {
          [ "$1" = 124 ] || [ "$1" = 137 ] || [ "$1" = 134 ] || [ "$1" = 139 ] || \
            grep -q -e 'ERR:' -e panic -e impossible -e exhausted -e 'stack overflow' \
                    -e Killed -e Segmentation -e 'out of memory' "$log"
        }
        sed -n '${toString from},${toString to}p' ${order} > chunk.txt
        test $(wc -l < chunk.txt) = ${toString (to - from + 1)}
        while read -r m path; do
          dir=$(dirname "$path"); hc="$odir/$dir/$m.hc"; hi="$odir/$dir/$m.hi"; log="$PWD/logs/$m.log"
          export TMPDIR="$NIX_BUILD_TOP/tmp/$m"; mkdir -p "$TMPDIR"
          extra=$(extra_flags "$path")
          srcf="$path"${lib.optionalString fixups ''; [ -f "$FIX/$path" ] && srcf="$FIX/$path"''}
          case "$path" in parser/Parser.hs) opt=-Onot ;; *) opt=-O ;; esac
          seed=$(awk -F'\t' -v m="$m" '$1==m {print $2}' ${flags} | tail -1)
          case "$seed" in *-fno-strictness*) opt="-O -fno-strictness" ;; -O0) opt=-O0 ;; esac
          rc=0; attempt "$opt" || rc=$?
          if [ "$rc" != 0 ] && retryable "$rc"; then
            case "$opt" in -O0|-Onot) ;; *)
              case "$opt" in *-fno-strictness*) ;; *) opt="$opt -fno-strictness"; rc=0; attempt "$opt" || rc=$? ;; esac
              if [ "$rc" != 0 ] && retryable "$rc"; then opt=-O0; rc=0; attempt "$opt" || rc=$?; fi ;;
            esac
          fi
          if [ "$rc" != 0 ] || [ ! -f "$hc" ] || [ ! -f "$hi" ]; then cat "$log"; echo "FAILED: $m"; exit 1; fi
          python3 ${hidict} "$hi" 0 "$m" >> "$log"
          echo "${stage} $m: OK ($opt)"
        done < chunk.txt

        runHook postBuild
      '';

      # The .hi-boot links point into the build directory
      installPhase = ''
        runHook preInstall

        find ${stage} -type l -delete
        mkdir "$out"
        cp -r ${stage} logs "$out/"

        runHook postInstall
      '';

      dontFixup = true;
    };

  hc1 = hcChunk {
    part = 1;
    from = 1;
    to = 111;
  };
  hc2 = hcChunk {
    part = 2;
    from = 112;
    to = 156;
    prev = hc1;
  };
  hc = hcChunk {
    part = 3;
    from = 157;
    to = 220;
    prev = hc2;
  };

  # Compiles the .hc files of `hc` with gcc, links the compiler and has it
  # compile Hello.hs.  With `ref`, the Hello.hc of the compiler `ref` is
  # compared with this one's and the result reported.
  linked =
    {
      stage,
      hc,
      ref ? null,
      passthru ? { },
    }:
    stdenv.mkDerivation {
      pname = "ghc-6.2.2-${stage}";
      version = "6.2.2";

      dontUnpack = true;

      nativeBuildInputs = [ python3Minimal ];
      buildInputs = [ gmp ];

      hardeningDisable = [ "all" ];

      buildPhase = ''
        runHook preBuild

        ulimit -s unlimited
        C=${src}/ghc/compiler
        ccflags="-std=gnu89 -O -w -fno-pie -DNO_REGS -DUSE_MINIINTERPRETER -D__GLASGOW_HASKELL__=602
                 -I${src}/ghc/includes -I$C/parser -I$C -I${src}/libraries/base/include"
        mkdir obj
        for hc in $(cd ${hc}/${stage} && find . -name '*.hc' | sort); do
          gcc -c -x c $ccflags -fwrapv -include ${src}/ghc/includes/Stg.h \
            "${hc}/${stage}/$hc" -o "obj/$(echo "''${hc#./}" | tr / _ | sed 's/\.hc$//').o"
        done
        test $(ls obj/*.o | wc -l) = 220
        gcc -c $ccflags "$C/parser/hschooks.c" -o obj/c_hschooks.o
        gcc -c $ccflags "$C/cbits/rawSystem.c" -o obj/c_rawSystem.o

        # The rts package's extra_ld_opts: 32 -u symbols
        u=$(grep -o '"-u", "[A-Za-z_0-9]*"' ${files}/stage2/topdir/package.conf | sed 's/"-u", "\(.*\)"/-u \1/')
        test $(echo "$u" | wc -l) = 32
        gcc -no-pie -o ghc obj/*.o -L${haskell98} -L${base}/lib -L${rts}/lib \
          -lHShaskell98 -lHSbase -lHSbase_cbits -lHSrts -lm -lgmp -ldl $u

        ${mkTopdir haskell98}
        mkdir test
        cp ${files}/test/Hello.hs test/Hello.hs
        (cd test && TMPDIR="$NIX_BUILD_TOP" ../ghc -B../topdir -v1 -C -O Hello.hs)
        python3 ${hidict} test/Hello.hi 0 Main${
          lib.optionalString (ref != null) ''

            if cmp -s test/Hello.hc ${ref}/test/Hello.hc; then
              echo "${ref.pname} and ${stage} agree on test/Hello.hc"
            else
              echo "${ref.pname} and ${stage} DIFFER on test/Hello.hc: $(diff test/Hello.hc ${ref}/test/Hello.hc | grep -c '^[<>]') lines"
            fi''
        }

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        install -D ghc "$out/bin/ghc"
        cp -r topdir "$out/topdir"
        mkdir "$out/test"
        cp test/Hello.hc test/Hello.hi "$out/test/"

        runHook postInstall
      '';

      dontStrip = true;

      passthru = passthru // {
        inherit hc;
      };
    };
in
linked {
  stage = "stage2";
  inherit hc;
  passthru = {
    inherit
      src
      haskell98
      hc1
      hc2
      hcChunk
      linked
      ;
  };
}
