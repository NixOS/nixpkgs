{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  isPyPy,

  # build-system
  cmake,
  ninja,
  setuptools,

  # buildInputs
  libxml2,
  llvm_22,

  # tests
  pytestCheckHook,

  withStaticLLVM ? true,
}:

let
  llvm = llvm_22;
in

buildPythonPackage (finalAttrs: {
  pname = "llvmlite";
  version = "0.49.0";
  pyproject = true;
  __structuredAttrs = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "numba";
    repo = "llvmlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AUte9llrcPl2z4ipkZ3PGeryDveZ9vj5oaBQtzGaT+w=";
  };

  build-system = [
    cmake
    ninja
    setuptools
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    llvm
  ]
  ++ lib.optionals withStaticLLVM [ libxml2.dev ];

  env.LLVMLITE_SHARED = !withStaticLLVM;

  pythonImportsCheck = [ "llvmlite" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  passthru = lib.optionalAttrs (!withStaticLLVM) { inherit llvm; };

  meta = {
    description = "Lightweight LLVM python binding for writing JIT compilers";
    homepage = "https://llvmlite.pydata.org/";
    downloadPage = "https://github.com/numba/llvmlite";
    changelog = "https://github.com/numba/llvmlite/blob/${finalAttrs.src.tag}/CHANGE_LOG";
    license = lib.licenses.bsd2;
  };
})
