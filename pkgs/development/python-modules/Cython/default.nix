{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, python
, glibcLocales
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
  pname = "Cython";
  version = "0.29.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zfBNB8NgCGDowuuq1Oj1KsP+shJFPBdkpJrAjIJ+hEM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  checkInputs = [
    gdb numpy ncurses
  ];

  buildInputs = [ glibcLocales ];
  LC_ALL = "en_US.UTF-8";

  patches = [
    # https://github.com/cython/cython/issues/2752, needed by sage (https://trac.sagemath.org/ticket/26855) and up to be included in 0.30
    (fetchpatch {
      name = "non-int-conversion-to-pyhash.patch";
      url = "https://github.com/cython/cython/commit/28251032f86c266065e4976080230481b1a1bb29.patch";
      sha256 = "19rg7xs8gr90k3ya5c634bs8gww1sxyhdavv07cyd2k71afr83gy";
    })

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
