# GHC 6.2.2 built by its own configure and make, with stage 3 as the
# bootstrapping compiler: unregisterised via C, without GHCi, the native code
# generator or profiling.
#
# A current toolchain still needs the runtime patches, the HTYPE_* block that
# configure no longer produces, C flags for 2004 C, -D_GNU_SOURCE for struct
# ucred, glibc's execvpe in place of the libraries' own, and GMP 6.1.2.  The
# chain's happy is 1.19.5, so the happy on the path is a wrapper that also
# applies the fix-ups for GHC 6.2.2.  The shipped generated sources are kept,
# since there is no alex for Lexer.x.
#
# The installed runtime system also gets GHC 6.4's fix for the compacting
# collector on x86-64 (rts-compact-x86_64.patch), which the chain itself
# never runs.
{
  lib,
  stdenv,
  perl,
  ghc-bootstrap-src,
  gmp,
  happy,
  tree,
  boot,
}:

let
  files = "${ghc-bootstrap-src}/ghc622";
in
stdenv.mkDerivation {
  pname = "ghc";
  version = "6.2.2";

  inherit (tree) src;

  postPatch = ''
    patchShebangs .
    for p in ${files}/rts/patches/*.patch ${./rts-compact-x86_64.patch}; do
      msg=$(patch -p1 -N -i "$p" 2>&1) || { echo "$msg"; echo "FAILED: $p"; exit 1; }
      case "$msg" in *fuzz*|*offset*) echo "$msg"; echo "INEXACT: $p"; exit 1 ;; esac
    done

    # glibc has had execvpe since 2.11, with a declaration that clashes with
    # the ones in libraries/unix and hslibs/posix.  The libraries' own
    # execvpe goes; pPrPr_disableITimers, in the same file, stays for
    # System.Posix.Process, which calls it before exec.
    sed -i '/^extern int execvpe(char \*name, char \*\*argv, char \*\*envp);$/d' libraries/unix/include/HsUnix.h
    ! grep -q execvpe libraries/unix/include/HsUnix.h
    sed -i \
      -e '/^int$/{N;s/^int\nexecvpe(char \*name, char \*\*argv, char \*\*envp)$/execvpe(char *name, char **argv, char **envp)/}' \
      -e '/^execvpe(char \*name, char \*\*argv, char \*\*envp)$/,/^}$/d' \
      libraries/unix/cbits/execvpe.c
    ! grep -q 'execvpe(' libraries/unix/cbits/execvpe.c
    grep -q '^void pPrPr_disableITimers (void)$' libraries/unix/cbits/execvpe.c
    sed -i '/^extern int  execvpe(char \*, char \*\*, char \*\*);$/d' hslibs/posix/cbits/HsPosix.h
    ! grep -q execvpe hslibs/posix/cbits/HsPosix.h

    # The rts package's options reach every C compile and link of the installed
    # compiler: C flags for the .hc files that include base's K&R HsBase.h,
    # non-PIE as the chain was verified, and GMP 6.1.2 for the programs it links
    sed -i \
      -e 's|^        library_dirs   =  \[ "\$libdir"$|        library_dirs   =  [ "$libdir", "${lib.getLib gmp}/lib"|' \
      -e 's/^        extra_cc_opts  = \[\],$/        extra_cc_opts  = [ "-std=gnu89", "-fpermissive", "-w", "-fwrapv", "-fno-pie" ],/' \
      -e '/^        extra_ld_opts  =$/{n;s/^         \[$/         [ "-no-pie",/}' \
      ghc/rts/package.conf.in
    grep -q '"\$libdir", "${lib.getLib gmp}/lib"' ghc/rts/package.conf.in
    grep -q '"-fwrapv", "-fno-pie" \],' ghc/rts/package.conf.in
    grep -q '^         \[ "-no-pie",$' ghc/rts/package.conf.in

    for g in $(find . -name '*.y' -o -name '*.ly' -o -name '*.x'); do
      hs="''${g%.*}.hs"
      [ -f "$hs" ] && { touch "$hs"; echo "keeping shipped $hs"; }
    done
    mkdir -p "$NIX_BUILD_TOP/bin"
    cat > "$NIX_BUILD_TOP/bin/happy" <<'EOF'
    #!${stdenv.shell}
    set -e
    ${lib.getExe happy} "$@"
    for a in "$@"; do
      case "$a" in
        *.y|*.ly) out="''${a%.*}.hs"; [ -f "$out" ] && sh ${files}/tools/fix-generated-parsers.sh "$out" ;;
      esac
    done
    EOF
    chmod +x "$NIX_BUILD_TOP/bin/happy"
    export PATH="$NIX_BUILD_TOP/bin:$PATH"

    cat > mk/build.mk <<'EOF'
    GhcUnregisterised = YES
    GhcWithNativeCodeGen = NO
    GhcWithInterpreter = NO
    GhcLibWays =
    GhcRTSWays =
    SplitObjs = NO
    GhcLibsWithReadline = NO
    SGMLDocWays =
    XMLDocWays =
    GHC_HAPPY_OPTS =
    SRC_HAPPY_OPTS =
    SRC_CC_OPTS += -std=gnu89 -fpermissive -w -fwrapv -D_GNU_SOURCE
    SRC_HC_OPTS += -optc-std=gnu89 -optc-fpermissive -optc-w -optc-fwrapv
    SRC_HSC2HS_OPTS += --cflag=-std=gnu89 --cflag=-fpermissive --cflag=-w --cflag=-D_GNU_SOURCE
    EOF
  '';

  nativeBuildInputs = [
    perl
    boot
  ];
  buildInputs = [ gmp ];

  hardeningDisable = [ "all" ];

  env = boot.nonPie;

  # The installed compiler runs gcc by the path given here
  configurePhase = ''
    runHook preConfigure

    ./configure --prefix="$out" --with-ghc=${boot}/bin/ghc --with-gcc=${stdenv.cc}/bin/gcc \
      --host=x86_64-unknown-linux --build=x86_64-unknown-linux --target=x86_64-unknown-linux
    grep -q 'with-ghc=${boot}/bin/ghc' config.log
    grep -q '^WhatGccIsCalled[[:space:]]*=[[:space:]]*${stdenv.cc}/bin/gcc$' mk/config.mk
    grep -q '^HostArch_CPP[[:space:]]*=[[:space:]]*x86_64' mk/config.mk
    grep -Eq '^HAPPY[[:space:]]*=[[:space:]]*'"$NIX_BUILD_TOP"'/bin/happy$' mk/config.mk
    gcc -O -w -o gen-htypes ${files}/tools/gen-htypes.c
    ./gen-htypes >> mk/config.h
    grep -q '^#define HTYPE_INT ' mk/config.h

    runHook postConfigure
  '';

  # fptools' make loops carry on past a failing subdirectory, so the output of
  # every make is searched for errors afterwards
  buildPhase = ''
    runHook preBuild

    ulimit -s unlimited
    export PATH="$NIX_BUILD_TOP/bin:$PATH"
    checked() { "$@" 2>&1 | tee -a make.log; test "''${PIPESTATUS[0]}" = 0; }
    checked make boot
    checked make
    ! grep -n '\*\*\* \[' make.log || { echo "a make step failed above"; exit 1; }

    runHook postBuild
  '';

  enableParallelBuilding = false;

  installPhase = ''
    runHook preInstall

    export PATH="$NIX_BUILD_TOP/bin:$PATH"
    make install 2>&1 | tee install.log
    test "''${PIPESTATUS[0]}" = 0
    ! grep -n '\*\*\* \[' install.log || { echo "a make install step failed above"; exit 1; }

    runHook postInstall
  '';

  dontStrip = true;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/ghc" --numeric-version | grep -qx 6.2.2
    "$out/bin/ghc-pkg" -l
    mkdir t
    cp ${files}/test/Hello.hs t/Hello.hs
    (cd t && "$out/bin/ghc" -v0 --make Hello.hs -o hello && ./hello)
    # Zero Integers kept live across garbage collections, which GMP 6.2 and
    # later break
    cp ${ghc-bootstrap-src}/common/test/GmpZero.hs t/GmpZero.hs
    (cd t && "$out/bin/ghc" -v0 -O --make GmpZero.hs -o gz && ./gz > gz.txt && printf "(2400000,0)\n" | diff - gz.txt)
    # System.Posix.Process links against libraries/unix/cbits
    printf 'import System.Posix.Process\nmain = forkProcess (return ()) >>= getProcessStatus True False >>= print\n' > t/Fork.hs
    (cd t && "$out/bin/ghc" -v0 -package unix --make Fork.hs -o fork && [ "$(./fork)" = "Just (Exited ExitSuccess)" ])
    # The compacting collector on every major collection (rts-compact-x86_64.patch)
    printf 'main = let xs = [1 .. 300000 :: Int] in print (length xs, sum xs)\n' > t/Compact.hs
    (cd t && "$out/bin/ghc" -v0 --make Compact.hs -o compact && [ "$(./compact +RTS -c -K64m -RTS)" = "(300000,45000150000)" ])

    runHook postInstallCheck
  '';

  passthru = { inherit (boot) nonPie; };

  meta = {
    description = "Glasgow Haskell Compiler 6.2.2, bootstrapped from source through Hugs and MicroHs";
    homepage = "https://github.com/andreabedini/ghc-bootstrap";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ghc";
    platforms = [ "x86_64-linux" ];
    # Hugs does not build with musl
    badPlatforms = lib.systems.inspect.patterns.isMusl;
  };
}
