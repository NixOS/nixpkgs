{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, glibcLocales
, pkgconfig
, gdb
, numpy
, ncurses
}:

let
  excludedTests = []
    ++ [ "reimport_from_subinterpreter" ]
    # cython's testsuite is not working very well with libc++
    # We are however optimistic about things outside of testsuite still working
    ++ stdenv.lib.optionals (stdenv.cc.isClang or false) [ "cpdef_extern_func" "libcpp_algo" ]
    # Some tests in the test suite isn't working on aarch64. Disable them for
    # now until upstream finds a workaround.
    # Upstream issue here: https://github.com/cython/cython/issues/2308
    ++ stdenv.lib.optionals stdenv.isAarch64 [ "numpy_memoryview" ]
    ++ stdenv.lib.optionals stdenv.isi686 [ "future_division" "overflow_check_longlong" ]
  ;

in buildPythonPackage rec {
  pname = "Cython";
  version = "unstable-2019-10-14"; # includes python3.8 fixes

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "70dd7561d431f248e20c2a1365111418ea494cbd";
    sha256 = "0l7h6z46a4870hwbi4g56f5lh1x78162yy5vzjz4ddzzgm7wap6a";
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  checkInputs = [
    numpy ncurses
  ];
  buildInputs = [ glibcLocales gdb ];
  LC_ALL = "en_US.UTF-8";

  checkPhase = ''
    export HOME="$NIX_BUILD_TOP"
    ${python.interpreter} runtests.py -j$NIX_BUILD_CORES \
      --no-code-style \
      ${stdenv.lib.optionalString (builtins.length excludedTests != 0)
        ''--exclude="(${builtins.concatStringsSep "|" excludedTests})"''}
  '';

  # https://github.com/cython/cython/issues/2785
  # Temporary solution
  doCheck = false;

#   doCheck = !stdenv.isDarwin;


  meta = {
    description = "An optimising static compiler for both the Python programming language and the extended Cython programming language";
    homepage = https://cython.org;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
