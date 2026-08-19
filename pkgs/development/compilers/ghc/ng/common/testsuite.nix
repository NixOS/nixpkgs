# GHC's own testsuite, run against an assembled compiler.
#
# The testsuite is a python driver (`driver/runtests.py`) wrapped in makefiles.
# Hadrian has its own entry point for it, but the driver does not need hadrian:
# `mk/boilerplate.mk` takes the compiler under test as `TEST_HC` and derives
# everything else from it. That is exactly the interface this package set wants,
# and it is why the testsuite needs no equivalent of the build-system rewrite.
#
# The compiler has to be a *complete* installation: `boilerplate.mk` hard-errors
# unless `hsc2hs`, `hp2ps` and `hpc` sit beside `ghc`. `assemble.nix` ships them
# for that reason.
#
# Native only. The driver compiles each test and then runs it, so a cross
# compiler has nothing to run the results on; upstream handles that with
# `iserv`, which this package set does not build yet.
{
  lib,
  stdenv,
  runCommand,
  python3,
  gnumake,
  which,
  diffutils,
  git,
  ghc,

  # `ghcSrc.testsuiteSrc`: a tree whose top level is `driver/`, `tests/`, `mk/`.
  # A release publishes it as its own tarball; a git checkout carries it inline.
  testsuiteSrc,

  # Which directory under `tests/` to run. The default is a small representative
  # one: a full run takes hours and exercises RTS ways, profiling libraries and
  # haddock that this package set does not build yet.
  #
  # `null` runs the whole suite.
  testDir ? "programs",

  # Which RTS ways to test. Only `v` is built, so only `normal` can be run.
  ways ? "normal",

  makeFlags ? [ ],
}:

assert lib.assertMsg (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
  "ghc/ng: the testsuite runs the programs it compiles, so it is native-only";

runCommand "ghc-testsuite-${ghc.version}"
  {
    nativeBuildInputs = [
      python3
      gnumake
      # `mk/boilerplate.mk` canonicalises every tool path through `which`, and
      # the driver diffs expected output.
      which
      diffutils
      # `driver/perf_notes.py:inside_git_repo` catches `CalledProcessError` but
      # not `FileNotFoundError`, so it degrades gracefully when git exists and
      # fails, and dies with a traceback when git is simply absent. With git
      # present it takes the intended path and skips the performance tests,
      # which have no baseline here anyway.
      git
      stdenv.cc
    ];

    meta = {
      description = "GHC's testsuite, run against ghc-${ghc.version}";
      license = lib.licenses.bsd3;
    };
  }
  ''
    # The driver writes into the test directories, so the tree must be writable.
    cp -r ${testsuiteSrc} testsuite
    chmod -R u+w testsuite

    # Several tests consult $HOME, and the sandbox has none.
    export HOME="$PWD/home"
    mkdir -p "$HOME"

    # NB: no comments inside the command below -- a `#` line between two
    # backslash continuations silently truncates it, which is how `| tee` went
    # missing once already.
    #
    # `METRICS_FILE` keeps the performance tests from wanting baselines out of
    # git notes; there is no checkout here to hold any.
    make -C testsuite${lib.optionalString (testDir != null) "/tests/${testDir}"} \
      ${lib.escapeShellArgs makeFlags} \
      TEST_HC=${ghc}/bin/ghc \
      GHC_PKG=${ghc}/bin/ghc-pkg \
      METRICS_FILE=$PWD/metrics.txt \
      WAYS=${ways} \
      THREADS=''${NIX_BUILD_CORES:-1} \
      2>&1 | tee test.log

    # `make` exits 0 even with unexpected failures, so the summary is the
    # verdict. Anything unexpected -- a failure, a pass, or a framework error --
    # fails the derivation.
    for kind in "unexpected failures" "unexpected passes" \
                "unexpected stat failures" "caused framework failures"; do
      n=$(sed -n "s/^ *\([0-9][0-9]*\) $kind\$/\1/p" test.log | tail -1)
      if [ -z "$n" ]; then
        echo "error: testsuite printed no '$kind' line; did it run at all?" >&2
        exit 1
      fi
      if [ "$n" != "0" ]; then
        echo "error: $n $kind" >&2
        exit 1
      fi
    done

    mkdir -p "$out"
    cp test.log "$out/test.log"
  ''
