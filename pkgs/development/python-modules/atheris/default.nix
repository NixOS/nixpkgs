{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonAtLeast,
  pythonOlder,
  runCommand,
  setuptools,
  pybind11,
  llvmPackages,
}:

buildPythonPackage (finalAttrs: {
  pname = "atheris";
  version = "3.1.0";
  pyproject = true;

  # Atheris hooks deeply into CPython internals, so it only works with the interpreter versions
  # upstream explicitly supports.
  disabled = pythonOlder "3.11" || pythonAtLeast "3.15";

  src = fetchFromGitHub {
    owner = "google";
    repo = "atheris";
    # 3.1.0 was released to PyPI as wheels only, without a git tag; this is the commit that bumped
    # the version and added CPython 3.14 support.
    rev = "352d5f29d811e0b51807ca57ed5551dd08ece528";
    hash = "sha256-LT6pjTNOhXeL76w2HTiHsBy9cv3W5CGwGPP/qKskJBU=";
  };

  # setup.py shells out to these helper scripts, whose `#!/bin/bash` shebangs are not valid inside
  # the build sandbox.
  postPatch = ''
    patchShebangs setup_utils/

    # The libFuzzer/sanitizer merge step copies the sanitizer archive out of the
    # read-only compiler-rt store path and then runs `ar d` on it, which fails
    # unless the copy is writable. Use `install` so the copy is always writable;
    # otherwise the merged asan_with_fuzzer.so / ubsan_with_fuzzer.so libraries
    # used for fuzzing native extensions are silently skipped.
    substituteInPlace setup_utils/merge_libfuzzer_sanitizer.sh \
      --replace-fail \
        'cp "$sanitizer" "$tmp_sanitizer"' \
        'install -m644 "$sanitizer" "$tmp_sanitizer"'
  '';

  # Point Atheris at the libFuzzer archive shipped with LLVM's compiler-rt instead of letting it
  # discover one via `clang -print-search-dirs`.
  env.LIBFUZZER_LIB = "${llvmPackages.compiler-rt}/lib/linux/libclang_rt.fuzzer_no_main-${stdenv.hostPlatform.parsed.cpu.name}.a";

  build-system = [
    setuptools
    pybind11
  ];

  pythonImportsCheck = [ "atheris" ];

  passthru.tests = {
    # Smoke test that exercises the full fuzzing pipeline: instrument a target, let libFuzzer's
    # coverage feedback drive it to a planted crash, and assert the Python exception is surfaced.
    # This catches breakage in the native extensions and the libFuzzer linkage that a plain import
    # check would miss.
    smoke =
      runCommand "atheris-smoke-test"
        {
          nativeBuildInputs = [ (python.withPackages (ps: [ finalAttrs.finalPackage ])) ];
        }
        ''
          cat > fuzz.py <<'EOF'
          import atheris
          import sys


          @atheris.instrument_func
          def TestOneInput(data):
              if data[:4] == b"FUZZ":
                  raise RuntimeError("smoke-test crash reached")


          atheris.Setup(sys.argv, TestOneInput)
          atheris.Fuzz()
          EOF

          # libFuzzer exits 77 once the target raises; a fixed seed keeps the run
          # deterministic and the run cap prevents hangs if coverage ever breaks.
          # The captured crash is the expected, successful outcome, so only the
          # raw fuzzer log is surfaced when something actually goes wrong.
          rc=0
          log="$(python fuzz.py -seed=1 -runs=5000000 2>&1)" || rc=$?

          fail() {
            echo "atheris smoke test FAILED: $1" >&2
            echo "--- fuzzer output ---" >&2
            echo "$log" >&2
            exit 1
          }

          [ "$rc" -eq 77 ] || fail "expected libFuzzer to report a crash (exit 77), got exit $rc"
          grep -q "smoke-test crash reached" <<<"$log" \
            || fail "coverage-guided fuzzing did not reach the planted crash"

          echo "atheris smoke test PASSED: coverage-guided fuzzing reached the planted crash"
          touch "$out"
        '';
  };

  meta = {
    description = "Coverage-guided, native Python fuzzer";
    homepage = "https://github.com/google/atheris";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ekzyis ];
    # libFuzzer discovery and the sanitizer merge steps are Linux-specific here.
    platforms = lib.platforms.linux;
  };
})
