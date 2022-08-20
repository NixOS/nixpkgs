{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, python
, pkg-config
, gdb
, numpy
, ncurses
}:

let
  excludedTests = [ "reimport_from_subinterpreter" ]
    # cython's testsuite is not working very well with libc++
    # We are however optimistic about things outside of testsuite still working
    ++ lib.optionals (stdenv.cc.isClang or false) [ "cpdef_extern_func" "libcpp_algo" ]
    # Some tests in the test suite isn't working on aarch64. Disable them for
    # now until upstream finds a workaround.
    # Upstream issue here: https://github.com/cython/cython/issues/2308
    ++ lib.optionals stdenv.isAarch64 [ "numpy_memoryview" ]
    ++ lib.optionals stdenv.isi686 [ "future_division" "overflow_check_longlong" ]
  ;

in buildPythonPackage rec {
  pname = "cython";
  version = "0.29.30";

  src = fetchPypi {
    pname = "Cython";
    inherit version;
    sha256 = "sha256-IjW2Laj+b6i5lCLI5YPy+5XhQ4Z9M3tcdeS5oahl+eM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  checkInputs = [
    gdb numpy ncurses
  ];

  LC_ALL = "en_US.UTF-8";

  patches = [
    # backport Cython 3.0 trashcan support (https://github.com/cython/cython/pull/2842) to 0.X series.
    # it does not affect Python code unless the code explicitly uses the feature.
    # trashcan support is needed to avoid stack overflows during object deallocation in sage (https://trac.sagemath.org/ticket/27267)
    (fetchpatch {
      name = "trashcan.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/cython/patches/trashcan.patch?id=4569a839f070a1a38d5dbce2a4d19233d25aeed2";
      sha256 = "sha256-+pOF1XNTEtNseLpqPzrc1Jfwt5hGx7doUoccIhNneYY=";
    })
  ];

  checkPhase = ''
    export HOME="$NIX_BUILD_TOP"
    ${python.interpreter} runtests.py -j$NIX_BUILD_CORES \
      --no-code-style \
      ${lib.optionalString (builtins.length excludedTests != 0)
        ''--exclude="(${builtins.concatStringsSep "|" excludedTests})"''}
  '';

  # https://github.com/cython/cython/issues/2785
  # Temporary solution
  doCheck = false;
  # doCheck = !stdenv.isDarwin;

  meta = {
    description = "An optimising static compiler for both the Python programming language and the extended Cython programming language";
    homepage = "https://cython.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
