{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  isPyPy,
  pythonAtLeast,

  # build-system
  llvm,
  setuptools,

  # tests
  python,
}:

buildPythonPackage rec {
  pname = "llvmlite";
  version = "0.42.0";
  pyproject = true;

  disabled = isPyPy || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "numba";
    repo = "llvmlite";
    rev = "refs/tags/v${version}";
    hash = "sha256-vN2npyAyN6C340l69YSRtRJrAe4EHSqh4SCgWfeSQaQ=";
  };

  nativeBuildInputs = [
    llvm
    setuptools
  ];

  # Disable static linking
  # https://github.com/numba/llvmlite/issues/93
  postPatch = ''
    substituteInPlace ffi/Makefile.linux --replace "-static-libstdc++" ""

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
    downloadPage = "https://github.com/numba/llvmlite";
    homepage = "http://llvmlite.pydata.org/";
    license = licenses.bsd2;
  };
}
