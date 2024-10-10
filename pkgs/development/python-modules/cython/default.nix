{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python,
  pkg-config,
  gdb,
  numpy,
  ncurses,

  # Reverse dependency
  sage,
}:

let
  excludedTests =
    [ "reimport_from_subinterpreter" ]
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
  version = "3.0.11";
  pyproject = true;

  src = fetchPypi {
    pname = "cython";
    inherit version;
    hash = "sha256-cUbdKvhoK0ymEzGFHmrrzp/lFY51MAND+AwHyoCx+v8=";
  };

  build-system = [
    pkg-config
    setuptools
  ];

  nativeCheckInputs = [
    gdb
    numpy
    ncurses
  ];

  env.LC_ALL = "en_US.UTF-8";

  checkPhase = ''
    export HOME="$NIX_BUILD_TOP"
    ${python.interpreter} runtests.py -j$NIX_BUILD_CORES \
      --no-code-style \
      ${
        lib.optionalString (
          builtins.length excludedTests != 0
        ) ''--exclude="(${builtins.concatStringsSep "|" excludedTests})"''
      }
  '';

  # https://github.com/cython/cython/issues/2785
  # Temporary solution
  doCheck = false;
  # doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.tests = {
    inherit sage;
  };

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
