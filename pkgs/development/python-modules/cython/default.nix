{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gdb,
  isPyPy,
  ncurses,
  numpy,
  pkg-config,
  pygame-ce,
  python,
  sage, # Reverse dependency
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  pname = "cython";
  version = "3.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cython";
    repo = "cython";
    tag = version;
    hash = "sha256-qFj7w0fQY6X1oADLsAgwFefzx92/Pmgv9j5S6v0sdPg=";
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

  env = lib.optionalAttrs (!isPyPy) {
    LC_ALL = "en_US.UTF-8";
  };

  # https://github.com/cython/cython/issues/2785
  # Temporary solution
  doCheck = false;

  strictDeps = true;

  checkPhase =
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
      # Some tests in the test suite aren't working on aarch64.
      # Disable them for now until upstream finds a workaround.
      # Upstream issue: https://github.com/cython/cython/issues/2308
      ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "numpy_memoryview" ]
      ++ lib.optionals stdenv.hostPlatform.isi686 [
        "future_division"
        "overflow_check_longlong"
      ];
      commandline = builtins.concatStringsSep " " (
        [
          "-j$NIX_BUILD_CORES"
          "--no-code-style"
        ]
        ++ lib.optionals (builtins.length excludedTests != 0) [
          ''--exclude="(${builtins.concatStringsSep "|" excludedTests})"''
        ]
      );
    in
    ''
      runHook preCheck
      export HOME="$NIX_BUILD_TOP"
      ${python.interpreter} runtests.py ${commandline}
      runHook postCheck
    '';

  passthru.tests = {
    inherit pygame-ce sage;
  };

  # Force code regeneration in source distributions
  # https://github.com/cython/cython/issues/5089
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://cython.org";
    description = "Optimising static compiler for both the Python and the extended Cython programming languages";
    longDescription = ''
      Cython is an optimising static compiler for both the Python programming
      language and the extended Cython programming language (based on Pyrex). It
      makes writing C extensions for Python as easy as Python itself.

      Cython gives you the combined power of Python and C to let you:

      - write Python code that calls back and forth from and to C or C++ code
        natively at any point.
      - easily tune readable Python code into plain C performance by adding
        static type declarations, also in Python syntax.
      - use combined source code level debugging to find bugs in your Python,
        Cython and C code.
      - interact efficiently with large data sets, e.g. using multi-dimensional
        NumPy arrays.
      - quickly build your applications within the large, mature and widely used
        CPython ecosystem.
      - integrate natively with existing code and data from legacy, low-level or
        high-performance libraries and applications.

      The Cython language is a superset of the Python language that additionally
      supports calling C functions and declaring C types on variables and class
      attributes. This allows the compiler to generate very efficient C code
      from Cython code.
    '';
    changelog = "https://github.com/cython/cython/blob/${version}/CHANGES.rst";
    license = lib.licenses.asl20;
    mainProgram = "cython";
    maintainers = [ ];
  };
}
# TODO: investigate recursive loop when doCheck is true
