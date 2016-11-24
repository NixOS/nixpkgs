{ stdenv
, fetchurl
, python
, buildPythonPackage
, isPy27
, isPy33
, isPy3k
, numpy
, llvmlite
, argparse
, funcsigs
, singledispatch
, libcxx
}:

buildPythonPackage rec {
  version = "0.29.0";
  name = "numba-${version}";

  src = fetchurl {
    url = "mirror://pypi/n/numba/${name}.tar.gz";
    sha256 = "00ae294f3fb3a99e8f0a9f568213cebed26675bacc9c6f8d2e025b6d564e460d";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [numpy llvmlite argparse] ++ stdenv.lib.optional (!isPy3k) funcsigs ++ stdenv.lib.optional (isPy27 || isPy33) singledispatch;

  # Copy test script into $out and run the test suite.
  checkPhase = ''
    cp runtests.py $out/${python.sitePackages}/numba/runtests.py
    ${python.interpreter} $out/${python.sitePackages}/numba/runtests.py
  '';
  # ImportError: cannot import name '_typeconv'
  doCheck = false;

  meta =  {
    homepage = http://numba.pydata.org/;
    license = stdenv.lib.licenses.bsd2;
    description = "Compiling Python code using LLVM";
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}