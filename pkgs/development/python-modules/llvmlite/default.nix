{ stdenv
, fetchurl
, buildPythonPackage
, python
, llvm
, pythonOlder
, isPyPy
, enum34
}:

buildPythonPackage rec {
  pname = "llvmlite";
  name = "${pname}-${version}";
  version = "0.15.0";

  disabled = isPyPy;

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "c855835537eda61f3a0d19aedc44f006d5084a2d322aee8ffa87aa06bb800dc4";
  };

  propagatedBuildInputs = [ llvm ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34;

  # Disable static linking
  # https://github.com/numba/llvmlite/issues/93
  patchPhase = ''
    substituteInPlace ffi/Makefile.linux --replace "-static-libstdc++" ""

    substituteInPlace llvmlite/tests/test_binding.py --replace "test_linux" "nope"
  '';
  # Set directory containing llvm-config binary
  preConfigure = ''
    export LLVM_CONFIG=${llvm}/bin/llvm-config
  '';
  checkPhase = ''
    ${python.executable} runtests.py
  '';

  __impureHostDeps = stdenv.lib.optionals stdenv.isDarwin [ "/usr/lib/libm.dylib" ];

  passthru.llvm = llvm;

  meta = {
    description = "A lightweight LLVM python binding for writing JIT compilers";
    homepage = "http://llvmlite.pydata.org/";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
