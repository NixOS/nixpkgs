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
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "llvmlite";
  version = "0.43.0";
  pyproject = true;

  disabled = isPyPy || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "numba";
    repo = "llvmlite";
    rev = "refs/tags/v${version}";
    hash = "sha256-5QBSRDb28Bui9IOhGofj+c7Rk7J5fNv5nPksEPY/O5o=";
  };

  nativeBuildInputs = [
    llvm
    setuptools
  ];

  postPatch = ''
    substituteInPlace llvmlite/tests/test_binding.py \
      --replace-fail "test_linux" "nope"
  '';

  # Set directory containing llvm-config binary
  preConfigure = ''
    export LLVM_CONFIG=${llvm.dev}/bin/llvm-config
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  __impureHostDeps = lib.optionals stdenv.isDarwin [ "/usr/lib/libm.dylib" ];

  passthru.llvm = llvm;

  meta = {
    changelog = "https://github.com/numba/llvmlite/blob/v${version}/CHANGE_LOG";
    description = "Lightweight LLVM python binding for writing JIT compilers";
    downloadPage = "https://github.com/numba/llvmlite";
    homepage = "http://llvmlite.pydata.org/";
    license = lib.licenses.bsd2;
  };
}
