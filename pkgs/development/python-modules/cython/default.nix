{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gdb,
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
  version = "3.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cython";
    repo = "cython";
    rev = version;
    hash = "sha256-ZyDNv95eS9YrVHIh5C/Xq8OvfX1cnI3f9GjA+OfaONA=";
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

  # https://github.com/cython/cython/issues/2785
  # Temporary solution
  doCheck = false;

  strictDeps = true;

  checkPhase =
    let
      excludedTests =
        [ "reimport_from_subinterpreter" ]
        # cython's testsuite is not working very well with libc++
        # We are however optimistic about things outside of testsuite still working
        ++ lib.optionals (stdenv.cc.isClang or false) [
          "cpdef_extern_func"
          "libcpp_algo"
        ]
        # Some tests in the test suite aren't working on aarch64.
        # Disable them for now until upstream finds a workaround.
        # Upstream issue: https://github.com/cython/cython/issues/2308
        ++ lib.optionals stdenv.isAarch64 [ "numpy_memoryview" ]
        ++ lib.optionals stdenv.isi686 [
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
    changelog = "https://github.com/cython/cython/blob/${version}/CHANGES.rst";
    description = "Optimising static compiler for both the Python programming language and the extended Cython programming language";
    homepage = "https://cython.org";
    license = lib.licenses.asl20;
  };
}
# TODO: investigate recursive loop when doCheck is true
