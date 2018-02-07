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
  name = "${pname}-${version}";
  version = "0.27.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a00512de1f2e3ce66ba35c5420babaef1fe2d9c43a8faab4080b0dbcc26bc64";
  };

  # With Python 2.x on i686-linux or 32-bit ARM this test fails because the
  # result is "3L" instead of "3", so let's fix it in-place.
  #
  # Upstream issue: https://github.com/cython/cython/issues/1548
  postPatch = lib.optionalString ((stdenv.isi686 || stdenv.isArm) && !isPy3k) ''
    sed -i -e 's/\(>>> *\)\(verify_resolution_GH1533()\)/\1int(\2)/' \
      tests/run/cpdef_enums.pyx
  '';

  nativeBuildInputs = [
    pkgconfig
    # For testing
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

  # Disable tests temporarily
  # https://github.com/cython/cython/issues/1676
  doCheck = false;

  meta = {
    description = "An optimising static compiler for both the Python programming language and the extended Cython programming language";
    homepage = http://cython.org;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
