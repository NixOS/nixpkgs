{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, python
, pythonOlder
, llvm
}:

buildPythonPackage rec {
  pname = "llvmlite";
  version = "0.40.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yRC4+/1nuOnQsQ68ASsjzWfL7O8blvANOR3dKY1xZxw=";
  };

  nativeBuildInputs = [
    llvm
  ];

  env.LLVMLITE_CXX_STATIC_LINK = 0;

  postPatch = ''
    substituteInPlace llvmlite/tests/test_binding.py --replace "test_linux" "nope"
  '';

  # Set directory containing llvm-config binary
  preConfigure = ''
    export LLVM_CONFIG=${llvm.dev}/bin/llvm-config
  '';

  checkPhase = ''
    runHook preCheck
    ${python.executable} runtests.py
    runHook postCheck
  '';

  __impureHostDeps = lib.optionals stdenv.isDarwin [ "/usr/lib/libm.dylib" ];

  passthru.llvm = llvm;

  meta = with lib; {
    changelog = "https://github.com/numba/llvmlite/blob/v${version}/CHANGE_LOG";
    description = "A lightweight LLVM python binding for writing JIT compilers";
    homepage = "http://llvmlite.pydata.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fridh ];
  };
}
