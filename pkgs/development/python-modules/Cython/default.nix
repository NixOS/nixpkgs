{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, python
, glibcLocales
, pkgconfig
, gdb
, numpy
, ncurses
}:

buildPythonPackage rec {
  pname = "Cython";
  version = "0.28.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "152ee5f345012ca3bb7cc71da2d3736ee20f52cd8476e4d49e5e25c5a4102b12";
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  checkInputs = [
    numpy ncurses
  ];
  buildInputs = [ glibcLocales gdb ];
  LC_ALL = "en_US.UTF-8";

  # cython's testsuite is not working very well with libc++
  # We are however optimistic about things outside of testsuite still working
  checkPhase = ''
    export HOME="$NIX_BUILD_TOP"
    ${python.interpreter} runtests.py \
      ${if stdenv.cc.isClang or false then ''--exclude="(cpdef_extern_func|libcpp_algo)"'' else ""}
  '';

  meta = {
    description = "An optimising static compiler for both the Python programming language and the extended Cython programming language";
    homepage = http://cython.org;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
