{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  python,
  pkg-config,
  pythonAtLeast,
  gdb,
  numpy,
  ncurses,
}:

let
  excludedTests = [
    "reimport_from_subinterpreter"
  ]
  # cython's testsuite is not working very well with libc++
  # We are however optimistic about things outside of testsuite still working
  ++ lib.optionals (stdenv.cc.isClang or false) [
    "cpdef_extern_func"
    "libcpp_algo"
  ]
  # Some tests in the test suite isn't working on aarch64. Disable them for
  # now until upstream finds a workaround.
  # Upstream issue here: https://github.com/cython/cython/issues/2308
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "numpy_memoryview" ]
  ++ lib.optionals stdenv.hostPlatform.isi686 [
    "future_division"
    "overflow_check_longlong"
  ];
in
buildPythonPackage rec {
  pname = "cython";
  version = "0.29.37.1";
  pyproject = true;

  # error: too few arguments to function '_PyLong_AsByteArray'
  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "cython";
    repo = "cython";
    rev = "refs/tags/${version}";
    hash = "sha256-XsEy2NrG7hq+VXRCRbD4BRaBieU6mVoE0GT52L3mMhs=";
  };

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

  nativeCheckInputs = [
    gdb
    numpy
    ncurses
  ];

  LC_ALL = "en_US.UTF-8";

  patches = [
    # backport Cython 3.0 trashcan support (https://github.com/cython/cython/pull/2842) to 0.X series.
    # it does not affect Python code unless the code explicitly uses the feature.
    # trashcan support is needed to avoid stack overflows during object deallocation in sage (https://trac.sagemath.org/ticket/27267)
    ./trashcan.patch
    # The above commit introduces custom trashcan macros, as well as
    # compiler changes to use them in Cython-emitted code. The latter
    # change is still useful, but the former has been upstreamed as of
    # Python 3.8, and the patch below makes Cython use the upstream
    # trashcan macros whenever available. This is needed for Python
    # 3.11 support, because the API used in Cython's implementation
    # changed: https://github.com/cython/cython/pull/4475
    (fetchpatch {
      name = "disable-trashcan.patch";
      url = "https://github.com/cython/cython/commit/e337825cdcf5e94d38ba06a0cb0188e99ce0cc92.patch";
      hash = "sha256-q0f63eetKrDpmP5Z4v8EuGxg26heSyp/62OYqhRoSso=";
    })
  ];

  checkPhase = ''
    export HOME="$NIX_BUILD_TOP"
    ${python.interpreter} runtests.py -j$NIX_BUILD_CORES \
      --no-code-style \
      ${lib.optionalString (
        excludedTests != [ ]
      ) ''--exclude="(${builtins.concatStringsSep "|" excludedTests})"''}
  '';

  # https://github.com/cython/cython/issues/2785
  # Temporary solution
  doCheck = false;
  # doCheck = !stdenv.hostPlatform.isDarwin;

  # force regeneration of generated code in source distributions
  # https://github.com/cython/cython/issues/5089
  setupHook = ./setup-hook.sh;

  meta = {
    changelog = "https://github.com/cython/cython/blob/${version}/CHANGES.rst";
    description = "Optimising static compiler for both the Python programming language and the extended Cython programming language";
    homepage = "https://cython.org";
    license = lib.licenses.asl20;
  };
}
