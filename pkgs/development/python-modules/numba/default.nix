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
  version = "0.46.0";
  pname = "numba";

  src = fetchFromGitHub {
    owner = "numba";
    repo = pname;
    rev = version;
    sha256 = "02gkpyp2xp4g76kpv71kggish8d5mds5lx6f9ng4lw0zmgkpz57j";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [
    numpy
    llvmlite
  ] ++ stdenv.lib.optional (!isPy3k) funcsigs ++ stdenv.lib.optional (isPy27 || isPy33) singledispatch;

  postPatch = ''
    # versioneer hack to set version of github package
    echo "def get_versions(): return {'full': 'no-sha', 'version': '${version}'}" > numba/_version.py

    substituteInPlace setup.py \
      --replace "version=versioneer.get_version()," "version='${version}'," \
      --replace "cmdclass=cmdclass," ""
  '';

  checkPhase = ''
    pushd dist
    ${python.interpreter} -m numba.runtests --tags important
    popd
  '';

  meta =  {
    homepage = http://numba.pydata.org/;
    license = stdenv.lib.licenses.bsd2;
    description = "Compiling Python code using LLVM";
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
