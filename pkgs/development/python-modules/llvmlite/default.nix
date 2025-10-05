{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  isPyPy,
  pythonAtLeast,

  setuptools,

  cmake,
  ninja,

  llvm_20,
  libxml2,

  # tests
  pytestCheckHook,

  withStaticLLVM ? true,
}:

let
  llvm = llvm_20;
in

buildPythonPackage rec {
  pname = "llvmlite";
  version = "0.45.0";
  pyproject = true;

  disabled = isPyPy || pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "numba";
    repo = "llvmlite";
    tag = "v${version}";
    hash = "sha256-xONYpDGsx6lhbAjAqwFx5Vo3PxeFsblhZxkxTSjMWOE=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ llvm ] ++ lib.optionals withStaticLLVM [ libxml2.dev ];

  nativeCheckInputs = [ pytestCheckHook ];

  dontUseCmakeConfigure = true;

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  env.LLVMLITE_SHARED = !withStaticLLVM;

  passthru = lib.optionalAttrs (!withStaticLLVM) { inherit llvm; };

  meta = {
    changelog = "https://github.com/numba/llvmlite/blob/v${version}/CHANGE_LOG";
    description = "Lightweight LLVM python binding for writing JIT compilers";
    downloadPage = "https://github.com/numba/llvmlite";
    homepage = "http://llvmlite.pydata.org/";
    license = lib.licenses.bsd2;
  };
}
