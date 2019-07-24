{ stdenv
, fetchFromGitHub
, python
, buildPythonPackage
, isPy27
, isPy33
, isPy3k
, numpy
, llvmlite
, funcsigs
, singledispatch
, libcxx
}:

buildPythonPackage rec {
  version = "0.45.0";
  pname = "numba";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1kb6jqwad8wy5nnk476g1vfbnyqv6lafz3mcyiwxdsi14hwps902";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [
    numpy
    llvmlite
  ] ++ stdenv.lib.optional (!isPy3k) funcsigs
    ++ stdenv.lib.optional (isPy27 || isPy33) singledispatch;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=versioneer.get_version()" "version='${version}'"
  '';

  checkPhase = ''
    runHook preCheck
    pushd dist
    ${python.interpreter} -m numba.runtests
    popd
    runHook postCheck
  '';

  meta =  {
    homepage = http://numba.pydata.org/;
    license = stdenv.lib.licenses.bsd2;
    description = "Compiling Python code using LLVM";
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
