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
  version = "0.29.32";

  src = fetchPypi {
    pname = "Cython";
    inherit version;
    hash = "sha256-hzPPR1i3kwTypOOev6xekjQbzke8zrJsElQ5iy+MGvc=";
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
      url = "https://github.com/cython/cython/commit/f781880b6780117660b2026caadf4a6d7905722f.patch";
      sha256 = "sha256-SnjaJdBZxm3O5gJ5Dxut6+eeVtZv+ygUUNwAwgoiFxg=";
    })
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
      sha256 = "sha256-q0f63eetKrDpmP5Z4v8EuGxg26heSyp/62OYqhRoSso=";
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
