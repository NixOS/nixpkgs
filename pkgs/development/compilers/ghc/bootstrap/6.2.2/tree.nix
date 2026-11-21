# GHC 6.2.2's source tree in the shape MicroHs compiles: the tarball with the
# patch series applied, configured for an unregisterised x86-64 build, with
# the parsers and primop tables regenerated and config.h completed.
{
  stdenv,
  runCommand,
  runCommandCC,
  fetchurl,
  perl,
  python3Minimal,
  ghc-bootstrap-src,
  mhs,
  mhsRuntime,
  cpphs,
  happy,
}:

let
  files = "${ghc-bootstrap-src}/ghc622";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/6.2.2/ghc-6.2.2-src.tar.bz2";
    hash = "sha256-oP5+uNRH8l+8YWzbziu04DlhqITCw3lp0eI1iLWIqFI=";
  };

  # parser/Lexer.hs as shipped (alex 2.0 output), its Addr# tables decoded into
  # boxed arrays.  No alex exists before GHC 6.2.2 is built.
  lexer = runCommand "ghc-6.2.2-Lexer.hs" { nativeBuildInputs = [ python3Minimal ]; } ''
    tar xjf ${src} --strip-components=4 ghc-6.2.2/ghc/compiler/parser/Lexer.hs
    python3 ${files}/tools/convert-lexer.py Lexer.hs "$out"
  '';

  # The three happy grammars, with the portable template, then the fix-ups that
  # make happy 1.19.5's output acceptable to GHC 6.2.2
  parsers = runCommand "ghc-6.2.2-parsers" { nativeBuildInputs = [ happy ]; } ''
    ys="main/ParsePkgConf parser/ParserCore parser/Parser"
    tar xjf ${src} --strip-components=3 $(for y in $ys; do echo "ghc-6.2.2/ghc/compiler/$y.y"; done)
    for y in $ys; do
      mkdir -p "$out/$(dirname "$y")"
      happy "$y.y" -o "$out/$y.hs"
      sh ${files}/tools/fix-generated-parsers.sh "$out/$y.hs"
    done
  '';

  # genprimopcode compiled by MicroHs, with its Parsec import served by a shim.
  # The C goes through a file of a fixed name, since `mhs -o` with a binary
  # compiles a temporary file whose random name stays in the symbol table.
  genprimopcode =
    runCommandCC "ghc-6.2.2-genprimopcode"
      {
        nativeBuildInputs = [
          mhs
          cpphs
        ];
        hardeningDisable = [ "all" ];
      }
      ''
        tar xjf ${src} --strip-components=4 ghc-6.2.2/ghc/utils/genprimopcode/Main.hs
        patch -s Main.hs ${files}/tools/genprimopcode-Main.hs.patch
        cp ${files}/shims/Parsec.hs Parsec.hs
        mhs -XCPP -i. -i${files}/shims-h98 Main -ogenprimopcode.c
        cc -w -O1 -I${mhsRuntime} -I${mhsRuntime}/unix \
          ${mhsRuntime}/main.c ${mhsRuntime}/eval.c genprimopcode.c -lm -o genprimopcode
        install -D genprimopcode "$out/bin/genprimopcode"
      '';

  # The tarball with the patch series applied exactly, configured, with the
  # headers ghc/includes/Makefile generates
  configured = stdenv.mkDerivation {
    pname = "ghc-6.2.2-configured";
    version = "6.2.2";
    inherit src;

    nativeBuildInputs = [ perl ];

    hardeningDisable = [ "all" ];

    patchPhase = ''
      runHook prePatch

      for p in ${files}/patches/*.patch; do
        msg=$(patch -p1 -N -i "$p" 2>&1) || { echo "$msg"; echo "FAILED: $p"; exit 1; }
        case "$msg" in *fuzz*|*offset*) echo "$msg"; echo "INEXACT: $p"; exit 1 ;; esac
      done

      runHook postPatch
    '';

    configurePhase = ''
      runHook preConfigure

      sh ./configure --enable-hc-boot --enable-hc-boot-unregisterised \
        --host=x86_64-unknown-linux --build=x86_64-unknown-linux --target=x86_64-unknown-linux
      grep -q '^HostArch_CPP[[:space:]]*=[[:space:]]*x86_64' mk/config.mk
      make -C ghc/includes config.h
      grep -q '^#define x86_64_TARGET_ARCH' ghc/includes/config.h

      runHook postConfigure
    '';

    # -no-pie: a PIE linked with unresolved symbols ignored has text relocations
    # that the loader refuses
    buildPhase = ''
      runHook preBuild

      for h in DerivedConstants:mkDerivedConstants NativeDefs:mkNativeHdr; do
        gcc -O2 -w -no-pie -include stdio.h -DNO_REGS -DUSE_MINIINTERPRETER -Ighc/includes \
          -Wl,--unresolved-symbols=ignore-all "ghc/includes/''${h#*:}.c" -o "''${h#*:}"
        "./''${h#*:}" > "ghc/includes/''${h%:*}.h"
        rm "''${h#*:}"
      done
      grep -Eq 'STD_ITBL_SIZE +3' ghc/includes/DerivedConstants.h
      grep -q OFFSET_R1 ghc/includes/NativeDefs.h

      runHook postBuild
    '';

    # config.log records the random names of gcc's temporary files
    installPhase = ''
      runHook preInstall

      rm config.log
      cp -a . "$out"

      runHook postInstall
    '';

    dontFixup = true;
  };

  # prelude/primops.txt and the ten tables ghc/compiler/Makefile makes from it.
  # Only cpphs --noline --strip reproduces the shipped primops.txt.
  primops =
    runCommand "ghc-6.2.2-primops"
      {
        nativeBuildInputs = [
          cpphs
          genprimopcode
        ];
      }
      ''
        T=${configured}/ghc
        mkdir "$out"
        cpphs --noline --strip "-I$T/includes" "$T/compiler/prelude/primops.txt.pp" > "$out/primops.txt"
        for pair in data-decl:data-decl primop-tag:tag primop-list:list \
                    has-side-effects:has-side-effects out-of-line:out-of-line \
                    commutable:commutable needs-wrapper:needs-wrapper can-fail:can-fail \
                    strictness:strictness primop-primop-info:primop-info; do
          genprimopcode --"''${pair%%:*}" < "$out/primops.txt" > "$out/primop-''${pair##*:}.hs-incl"
        done
      '';

  # main/Config.hs, as the compiler Makefile's rule writes it
  config = runCommandCC "ghc-6.2.2-config-hs" { } ''
    sh ${files}/tools/config-hs.sh ${configured} ${files}/gen/config-hs.mk "$out"
    grep -q '^cGhcUnregisterised    = "YES"$' "$out/Config.hs"
  '';

  # The HTYPE_* defines that configure's K&R probes no longer produce under
  # gcc 14 and later
  htypes = runCommandCC "ghc-6.2.2-htypes.h" { } ''
    gcc -O -w -o gen-htypes ${files}/tools/gen-htypes.c
    ./gen-htypes > "$out"
  '';
in
runCommand "ghc-6.2.2-tree"
  {
    passthru = {
      inherit
        src
        genprimopcode
        parsers
        primops
        config
        ;
    };
  }
  ''
    cp -a ${configured} "$out"
    chmod -R u+w "$out"
    C="$out/ghc/compiler"
    cp ${primops}/* "$C/prelude/"
    cp -r --no-preserve=mode ${parsers}/. "$C/"
    cp ${lexer} "$C/parser/Lexer.hs"

    H="$out/ghc/includes/config.h"
    tail -1 "$H" | grep -q '^#endif'
    { sed '$d' "$H"; cat ${htypes}; printf '\n#endif /* __FPTOOLS_CONFIG_H__ */\n'; } > config.h
    mv config.h "$H"
    grep -q '^#define HTYPE_INT ' "$H"

    ln -s ../../utils/ghc-pkg "$C/utils/ghc-pkg"
  ''
